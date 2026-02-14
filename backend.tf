terraform {
   backend s3 {
        bucket = "my-tf-state-bucket-vijaya"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
}