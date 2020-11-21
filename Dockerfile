FROM python:3.8-alpine3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add bash curl ffmpeg findutils && \
  curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/youtube-dl && \
  chmod a+rx /bin/youtube-dl

COPY \
  entrypoint.sh \
  yt-downloader.sh \
  cleanup.sh \
  /app/

ENV FETCH_INTERVAL 1d
ENV FILENAME_TEMPLATE '%(epoch)s-%(id)s.%(ext)s'
ENV AUDIO_QUALITY 9
ENV NUMBER_OF_ITEMS_TO_DOWNLOAD -1

ENTRYPOINT ["/app/entrypoint.sh"]
