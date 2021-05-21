setup() {
  echo 'PLAYLIST=https://www.youtube.com/playlist?list=PLiaEzfVtwOH-yseeaRj3Tv1LPq3O2tLyh' > env.list
  mkdir -p ./out
}

teardown () {
  rm env.list
  sudo rm -rf ./out
}

main () {
  docker run --rm \
    --entrypoint /app/download.sh \
    -v "$(pwd)/out":/out \
    --env-file env.list \
    localhost:5000/alexmisk/yt-downloader:latest
}

EMPTY_FOLDER_HASH=da39a3ee5e6b4b0d3255bfef95601890afd80709
FOLDER_WITH_ALL_EPISODES_HASH=d50e83af5f3836a70d936f2f97db446caf3a9f51
FOLDER_WITH_3_RECENT_EPISOES_HASH=8f2f8f880601baebaf1505d0d01089ad674260ab
FOLDER_WITH_CUSTOM_QUALITY_EPISOES_HASH=c9cdfbe146d7ac4a166e79bc0a27c57276935083

out_folder_hash () {
  sha1sum out/*.mp3 \
  | awk '{print $1}' \
  | sha1sum - \
  | awk '{print $1}'
}


@test "Fail if no PLAYLIST specified" {
  echo > env.list
  run main
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Nothing to download. Please set PLAYLIST environmental variable" ]]
  [ "$(out_folder_hash)" == $EMPTY_FOLDER_HASH ]
}

@test "Download with default parameters" {
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == $FOLDER_WITH_ALL_EPISODES_HASH ]
}

@test "Download only 3 last items" {
  echo "NUMBER_OF_ITEMS_TO_DOWNLOAD=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == $FOLDER_WITH_3_RECENT_EPISOES_HASH ]
}

@test "Download with custom audio quality" {
  echo "AUDIO_QUALITY=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == $FOLDER_WITH_CUSTOM_QUALITY_EPISOES_HASH]
}

@test "Save with custom filename template" {
  echo "FILENAME_TEMPLATE=new-template-%(id)s.%(ext)s" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(find ./out -name "new-template-*.mp3" | wc -l)" -eq 5 ]
}

