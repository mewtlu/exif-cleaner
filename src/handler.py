import json
import os
import urllib.parse
import boto3
from io import BytesIO
from exif_cleaner import clean_exif_data

s3_client = boto3.client('s3')

destination_bucket = os.environ['DESTINATION_BUCKET']

def handler(event, context):
    records = event.get('Records', [])
    print('Processing', len(records), 'records.')

    for record in records:
        source_bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'])

        print('Reading image with key', key, 'from bucket', source_bucket)

        # Fetch image from S3
        response = s3_client.get_object(Bucket=source_bucket, Key=key)
        raw_image = response['Body']

        # Clean EXIF data from image
        cleaned_image = clean_exif_data(raw_image)

        # Convert to a file-like
        cleaned_image_file = BytesIO()
        cleaned_image.save(cleaned_image_file, format='JPEG')
        cleaned_image_file.seek(0)

        # Save cleaned image back to destination S3 bucket
        s3_client.put_object(
            Bucket=destination_bucket,
            Key=key,
            Body=cleaned_image_file,
            ContentType=response.get('ContentType', 'image/jpeg')
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Successfully cleaned EXIF data from image(s).')
    }