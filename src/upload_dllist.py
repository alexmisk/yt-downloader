import boto3
import sys
import os

session = boto3.session.Session()

s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

bucket = 'podcast.alexmisk.ru'
s3.upload_file('/var/downloaded.txt', bucket, 'downloaded.txt')