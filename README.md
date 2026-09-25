# EXIF Cleaner

A microservice used to automatically strip the EXIF data from JPEG images uploaded into an S3 bucket, uploading the resultant cleaned images into another S3 bucket at the same path.

## Architecture

The service is designed to be run as a Lambda function which is triggered by each object create event in the source S3 bucket.

The infrastructure to deploy the service is defined in terraform under the `terraform/` directory.

## Configuration

The service is configured using environment variables, a list of which is shown in the table below.

| Environment Variable | Function |
|---|---|
| SOURCE_BUCKET        | Name of the source bucket to monitor for uploaded images. |
| DESTINATION_BUCKET   | Name of the destination bucket to write the cleaned images to. |

## Testing / Development

### Prerequisites

- Python 3 + pip
- Terraform

### Installing dependencies

Run `pip install -r requirements.txt` to use pip to install python dependencies.

### Running Tests

Use the `pytest` command to run tests.

### Deployment

Run the following commands to locally initialize terraform, then use terraform apply to deploy the service:

```bash
cd terraform
terraform init
terraform apply -var="target_bucket_name=$SOURCE_BUCKET" -var="cleaned_bucket_name=$DESTINATION_BUCKET"
```