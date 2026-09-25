terraform {
  backend "s3" {
    bucket         = "mewtlu-exif-cleaner-backend"
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true
  }
}