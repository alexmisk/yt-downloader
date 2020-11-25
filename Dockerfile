FROM python:3.8-alpine3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add bash curl ffmpeg findutils && \
  curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/youtube-dl && \
  chmod a+rx /bin/youtube-dl

ADD src /app 

ENV FETCH_INTERVAL 1d

ENTRYPOINT ["/app/entrypoint.sh"]
