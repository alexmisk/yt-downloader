FROM alpine:3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add curl python3 ffmpeg util-linux && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/youtube-dl && \
  chmod a+rx /bin/youtube-dl

COPY entrypoint.sh yt-downloader.sh /app/
ENV FETCH_INTERVAL 1d
ENTRYPOINT ["/app/entrypoint.sh"]
