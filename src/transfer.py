import boto3
from tinytag import TinyTag
import base64
import sys
import os

def encode(string):
    encodedBytes = base64.b64encode(string.encode("utf-8"))
    return str(encodedBytes, "utf-8")

session = boto3.session.Session()

s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

bucket = 'podcast.alexmisk.ru'
filename_with_path = sys.argv[1]
filename = os.path.basename(filename_with_path)
tag = TinyTag.get(filename)



enc_title = encode(tag.title)
enc_artist = encode(tag.artist)
enc_duration = str(tag.duration)


s3.upload_file(filename_with_path, bucket, 'media/' + filename, ExtraArgs={"Metadata": {"artist": enc_artist, "title": enc_title, "duration": enc_duration}})

