# Storage Module

The Storage module sets up the S3 bucket and related configurations.

## Resources

- S3 Bucket
- Bucket Policy
- Bucket ACL
- Bucket Versioning
- Bucket Lifecycle Configuration

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables. Here is an example:

```
module "storage" {
  source = "./modules/storage"
  bucket_name = "my-bucket"
  bucket_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
EOF
  acl = "public-read"
  versioning_status = "Enabled"
  lifecycle_rules = [
    {
      id     = "OldVersions"
      status = "Enabled"
      filter = [
        {
          prefix = ""
        }
      ]
      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
      noncurrent_version_expiration = [
        {
          days = 90
        }
      ]
    }
  ]
}
```

## Outputs:

- bucket_id: The ID of the S3 bucket.
- bucket_arn: The ARN of the S3 bucket.
