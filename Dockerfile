FROM python:3.9.15-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            python3-dev gcc curl build-essential
  
COPY requirements.txt /app
RUN pip install -r requirements.txt

ADD src /app

ENTRYPOINT ["python", "main.py"]
