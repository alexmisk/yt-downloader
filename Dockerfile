FROM alpine:3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add curl python3 ffmpeg && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/youtube-dl && \
  chmod a+rx /bin/youtube-dl

ADD yt-downloader.sh /app

CMD sh yt-downloader.sh
