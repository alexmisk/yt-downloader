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

out_folder_hash () {
  sha1sum out/*.mp3 \
  | awk '{print $1}' \
  | shasum - \
  | awk '{print $1}'
}


@test "Fail if no PLAYLIST specified" {
  echo > env.list
  run main
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Nothing to download. Please set PLAYLIST environmental variable" ]]
  [ "$(out_folder_hash)" == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]
}

@test "Download with default parameters" {
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == "b50fe34dce256081e738ecaf2d91050e472d8f32" ]
}

@test "Download only 3 last items" {
  echo "NUMBER_OF_ITEMS_TO_DOWNLOAD=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == "b52b06772e0283b245fc8fe009d287b0fd502f52" ]
}

@test "Download with custom audio quality" {
  echo "AUDIO_QUALITY=3" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(out_folder_hash)" == "afe5580e06d8fcf505ad2802b1201dc52c97942d" ]
}

@test "Save with custom filename template" {
  echo "FILENAME_TEMPLATE=new-template-%(id)s.%(ext)s" >> env.list
  run main
  [ "$status" -eq 0 ]
  [ "$(find ./out -name "new-template-*.mp3" | wc -l)" -eq 5 ]
}

