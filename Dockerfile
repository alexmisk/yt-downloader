FROM python:3.8-alpine3.12

WORKDIR /app

RUN \
  apk update && \
  apk --no-cache add bash curl ffmpeg findutils

COPY requirements.txt /app
RUN pip install -r requirements.txt

ADD src /app

ENTRYPOINT ["python", "app/main.py"]
