import boto3
import sys
import os

session = boto3.session.Session()

s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

bucket = 'podcast.alexmisk.ru'

try:
    s3.get_object_attributes(bucket, 'dl.lock')
except:
    s3.upload_file('/var/dl.lock', bucket, 'dl.lock')
    os.exit(1)
