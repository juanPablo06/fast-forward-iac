# IAM Module

The IAM module sets up IAM roles and policies.

## Resources

- IAM Role
- IAM Policies
- IAM Role Policy Attachments

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables. Here is an example:

```
module "iam" {
  source = "./modules/iam"
  role_name = "my-role"
  role_description = "My IAM role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  policy_names = ["my-policy"]
  policy_descriptions = ["My custom policy"]
  policy_documents = [<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
  ]
}
```

## Outputs:

- role_arn: The ARN of the IAM role.
- policy_arns: List of ARNs of the IAM policies.
