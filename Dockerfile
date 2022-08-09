FROM python:3.8-alpine3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add bash curl ffmpeg findutils && \
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /bin/youtube-dl && \
  chmod a+rx /bin/youtube-dl

COPY requirements.txt /app
RUN pip install -r requirements.txt

ADD src /app

ENTRYPOINT ["/app/entrypoint.sh"]
