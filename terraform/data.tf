data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240819.0-kernel-6.1-x86_64"]
  }

  owners = ["amazon"]
}
