# Networking Module

The Networking module sets up the Virtual Private Cloud (VPC) and related networking resources.

## Resources

- VPC
- Public and Private subnets
- Internet Gateway
- NAT Gateway
- Route Tables

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables. Here is an example:

```
module "networking" {
source = "./modules/networking"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
}
```

## Outputs:

- vpc_id: The ID of the VPC.
- public_subnet_ids: List of IDs of public subnets.
- private_subnet_ids: List of IDs of private subnets.
- internet_gateway_id: The ID of the Internet Gateway.
- nat_gateway_ids: List of IDs of NAT Gateways.
- public_route_table_ids: List of IDs of public route tables.
- private_route_table_ids: List of IDs of private route tables.