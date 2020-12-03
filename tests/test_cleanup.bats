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
    -v "$(pwd)/out":/out \
    --env-file env.list \
    localhost:5000/alexmisk/yt-downloader:latest
}

out_folder_hash () {
  # Used to compare desirable content in /out folder
  # Hashes:
  # - empty folder: da39a3ee5e6b4b0d3255bfef95601890afd80709
  # - folder with 5 episodes: afc87eec6d6a4f06d0a29b4db7f609a63abd6c45
  # - folder with 3 recent episodes: 99cf029c2241f8428989145c79c6af425275cd5b

  sha1sum out/*.mp3 \
    | shasum - \
    | awk '{print $1}'
}

@test "Fail if NUMBER_OF_EPISODES_TO_KEEP is not an integer" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=abc123" >> env.list
  rm -rf ./out/*.mp3
  run main
  [ "$status" -eq 1 ]
  [[ "$output" =~ "NUMBER_OF_EPISODES_TO_KEEP is not a number. Aborting..." ]]
  [ "$(out_folder_hash)" == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]
}

@test "Do nothing if NUMBER_OF_EPISODES_TO_KEEP > current number of episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=6" >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Nothing deleted" ]]
  [ "$(out_folder_hash)" == "afc87eec6d6a4f06d0a29b4db7f609a63abd6c45" ]
}

@test "Do nothing if NUMBER_OF_EPISODES_TO_KEEP = current number of episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=5" >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Nothing deleted" ]]
  [ "$(out_folder_hash)" == "afc87eec6d6a4f06d0a29b4db7f609a63abd6c45" ]
}

@test "Keep only 3 recent episodes" {
  echo "NUMBER_OF_EPISODES_TO_KEEP=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning: Deleted 2 episodes" ]]
  [ "$(out_folder_hash)" == "99cf029c2241f8428989145c79c6af425275cd5b" ]
}
