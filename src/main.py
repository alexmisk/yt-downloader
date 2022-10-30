import boto3
import sys
import os
import base64
from pathlib import Path
from yt_dlp import YoutubeDL
from yt_dlp.postprocessor import PostProcessor
from tinytag import TinyTag

session = boto3.session.Session()

s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

bucket = 'podcast.alexmisk.ru'

def encode(string):
    encodedBytes = base64.b64encode(string.encode("utf-8"))
    return str(encodedBytes, "utf-8")

class MyCustomPP(PostProcessor):
    def run(self, info):
        filename_with_path = info['filepath']
        filename = os.path.basename(filename_with_path)
        tag = TinyTag.get(filename_with_path)
        enc_title = encode(tag.title)
        enc_artist = encode(tag.artist)
        enc_duration = str(tag.duration)


        s3.upload_file(filename_with_path, bucket, 'media/' + filename, ExtraArgs={"Metadata": {"artist": enc_artist, "title": enc_title, "duration": enc_duration}})
        return [], info

try:

    try:
        s3.head_object(Bucket=bucket, Key='dl.lock')
    except:
        Path('dl.lock').touch()
        s3.upload_file('dl.lock', bucket, 'dl.lock')
    else:
        print('Lockfile found, terminating...')
        exit()

    try:
        s3.download_file(bucket, 'downloaded.txt', 'downloaded.txt')
    except:
        print('Download archive not found')

    ydl_opts = {
    'outtmpl': './media/%(id)s.%(ext)s',
    'download_archive': 'downloaded.txt',
    'format': 'mp3/bestaudio/best',
    'postprocessors': [
        {
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        },
        {
        'key': 'FFmpegMetadata',
        },
        ]
}
    try:
        PLAYLIST_URL = os.environ['PLAYLIST_URL']
    except:
        print('PLAYLIST_URL not set')
        exit(1)

    with YoutubeDL(ydl_opts) as ydl:
        ydl.add_post_processor(MyCustomPP(), when='post_process')
        ydl.download(PLAYLIST_URL)


    # s3.upload_file('downloaded.txt', bucket, 'downloaded.txt')


finally:
    s3.delete_object(Bucket=bucket, Key='dl.lock')
