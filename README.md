# yt-downloader
A simple Docker container for downloading YouTube playlists as MP3s

## Basic usage

Download all episodes
``` docker run -v "$(pwd)/out:/out" -e PLAYLIST=<youtube-playlist-url-here> ghcr.io/alexmisk/yt-downloader:latest ```
