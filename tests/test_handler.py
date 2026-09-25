import json
import os
from unittest.mock import MagicMock, patch
from io import BytesIO
from PIL import Image

os.environ['DESTINATION_BUCKET'] = os.getenv('DESTINATION_BUCKET', 'example-destination-bucket')

event = {
  'Records': [
    {
      's3': {
        'bucket': {
          'name': 'example-bucket'
        },
        'object': {
          'key': 'example-image.jpg'
        }
      }
    }
  ]
}

def test_function_handler():
    with patch('boto3.client') as mock_boto:
        # Create a very simple image to test with
        valid_image_stream = BytesIO()
        Image.new('RGB', (1, 1), color='red').save(valid_image_stream, format='JPEG')
        valid_image_stream.seek(0) # Reset pointer to start

        # Mock S3 client
        mock_s3 = MagicMock()
        mock_boto.return_value = mock_s3

        mock_s3.get_object.return_value = {
            'Body': valid_image_stream,
            'ContentType': 'image/jpeg'
        }

        # Import lambda handler
        import handler

        # Call handler with mock event and empty context
        response = handler.handler(event, None)

        # Print and validate results
        print('Response status:', response['statusCode'])
        print('\n--- Validation')
        mock_s3.get_object.assert_called_once_with(
            Bucket=event['Records'][0]['s3']['bucket']['name'],
            Key=event['Records'][0]['s3']['object']['key'],
        )
        print('- get_object called with correct parameters.')

        mock_s3.put_object.assert_called_once()
        put_args = mock_s3.put_object.call_args[1]
        print('- put_object called with key:', put_args['Key'], 'and bucket:', put_args['Bucket'])