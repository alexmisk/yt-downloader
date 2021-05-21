setup() {
  touch env.list
  mkdir -p ./out
  touch ./out/{1..5}.mp3
}

teardown () {
  rm env.list
  sudo rm -rf ./out
}

main () {
  docker run --rm \
    --entrypoint /app/cleanup.sh \
    --volume "$(pwd)/out":/out \
    --env-file env.list \
    localhost:5000/alexmisk/yt-downloader:latest
}

EMPTY_FOLDER_HASH=da39a3ee5e6b4b0d3255bfef95601890afd80709
FOLDER_WITH_ALL_EPISODES_HASH=d50e83af5f3836a70d936f2f97db446caf3a9f51
FOLDER_WITH_3_RECENT_EPISOES_HASH=8f2f8f880601baebaf1505d0d01089ad674260ab

out_folder_hash () {
  # Used to compare desirable content in /out folder

  sha1sum out/*.mp3 \
  	| awk '{print $1}' \
	| sha1sum - \
    | awk '{print $1}'
}

@test "Fail if NUMBER_OF_EPISODES_TO_KEEP is not an integer" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=abc123" >> env.list
  rm -rf ./out/*.mp3
  run main
  [ "$status" -eq 1 ]
  [[ "$output" =~ "NUMBER_OF_EPISODES_TO_KEEP is not a number. Aborting..." ]]
  [ "$(out_folder_hash)" == $EMPTY_FOLDER_HASH ]
}

@test "Do nothing if NUMBER_OF_EPISODES_TO_KEEP > current number of episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=6" >> env.list
  run main
  ls out
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Nothing deleted" ]]
  [ "$(out_folder_hash)" == $FOLDER_WITH_ALL_EPISODES_HASH ]
}

@test "Do nothing if NUMBER_OF_EPISODES_TO_KEEP = current number of episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=5" >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Nothing deleted" ]]
  [ "$(out_folder_hash)" == $FOLDER_WITH_ALL_EPISODES_HASH ]
}

@test "Keep only 3 recent episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Deleted 2 episodes" ]]
  [ "$(out_folder_hash)" == $FOLDER_WITH_3_RECENT_EPISOES_HASH ]
}
