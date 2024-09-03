# Database Module

The Database module sets up the RDS instance and related resources.

## Resources

- RDS Instance
- Security Group

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables. Here is an example:

```
module "database" {  
source = "./modules/database"
db_instance_class = "db.t3.micro"
db_name = "mydb"
db_username = "admin"
db_password = "password"
db_subnet_group_name = "my-db-subnet-group"
vpc_security_group_ids = [module.networking.vpc_id]
}
```

## Outputs:

- rds_address: The address of the RDS instance.
- rds_endpoint: The endpoint of the RDS instance.
- rds_instance_id: The ID of the RDS instance.