setup() {
  echo 'DEBUG=1' > env.list
}

teardown () {
  rm env.list
}

main () {
  docker run --rm \
    --entrypoint /app/sleep.sh \
    --volume "$(pwd)/out":/out \
    --env-file env.list \
    localhost:5000/alexmisk/yt-downloader:latest
}


@test "Sleep for 1 day if no FETCH_INTERVAL specified" {
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Sleep for 1d ..." ]]
}

@test "Sleep for specified FETCH_INTERVAL" {
  echo 'FETCH_INTERVAL=2d' >> env.list
  run main
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Sleep for 2d ..." ]]
}

