# fast-forward-iac

## 1. Dockerfile/docker-compose

### Building and running the application

Build and run the application on detached mode using docker compose by running:
`docker compose up -d - -build`.

The application will be available at http://localhost:8080.

### Scaling considerations

For horizontal scaling of the application using docker compose, you can add a --scale flag
to the `docker compose up` command and define how many replicas of the 
specific service you want to run (backend in our case). 
It can also be achieved declaratively by adding a replica definition to docker-compose.yml:

`deploy:
        replicas: 3`

This creates another requirement: distribute incoming requests across the replicas. 
To solve this issue we can can use a load balancer either external to Docker Compose or 
as another service within our docker-compose.yml, like nginx. 

We should consider container orchestration tools like Kubernetes or Docker Swarm for more complex applications.
These tools provide more advanced features for managing and scaling containerized applications like:
Autoscaling, high availability by distributing containers across multiple nodes, 
fault tolerance, scheduling for efficient resource management.
Docker Compose is great for local development and simple multi-container applications, 
but a container orchestration tool is necessary for large-scale production-grade applications.

# 2. Terraform Infrastructure

## 1. Setup Documentation

### Prerequisites

- An AWS account/role with appropriate permissions. 
- Terraform installed on your local machine or agent. 
- AWS CLI installed and configured. 

### Setup instructions

1. Clone the repository containing the terraform configuration files. 
2. Configure AWS credentials using the AWS CLI.
3. Initialize the Terraform working directory.

`terraform init`

4. Apply the Terraform configuration to deploy the infrastructure.
Use the appropriate variable file for your environment (e.g, development.tfvars)

`terraform apply -var-file="tfvars/development.tfvars"`

5. To modify parameters for different environments, modify the separate
variable files and update the value as needed. Use the appropriate variable file 
when applying the configuration. 

6. To destroy the infrastructure when it is no longer needed, use the `terraform destroy`
command with the appropriate variable file.

`terraform destroy -var-file="tfvars/production.tfvars"`


### Troubleshooting Tips

- **Terraform initialization issues**: If you encounter issues during `terraform init`
ensure that your AWS credentials are correctly configured and that you have internet access to
download the provider plugins. 

- If Terraform fails to create resources, check the error messages related to the failed resources. 
They usually give a good glance on what might be wrong. Ensure that you have the necessary permissions
to create the resources.

- If you cannot connect to your EC2 instances, verify that the security groups allow SSH access. 

- If you cannot connect to the RDS instance from your EC2 instances, verify that the security groups allow
access from the EC2 instances. Ensure that the database credentials are correct. 

- If you cannot access files in the S3 bucket, verify that the bucket policies and ACLs are correctly
configured to allow public read access. Ensure that the files are correctly uploaded to the bucket. 


## 2. Test and Validation: 

### Ensuring EC2 Instances Can Serve Web Traffic and Scale Correctly

1. **Access the Web server:** Obtain the public DNS name of the ALB and access it
via a web browser to verify that the web server is serving traffic. 

`curl http://<ALB_DNS_NAME>`

2. **Simulate Load:** Use a load testing tool such as Locust to simulate traffic and verify
that the ASG scales the EC2 instances up and down based on CPU utilization. 

3. **Check Scaling:** Monitor the ASG in the AWS Console to ensure that instances are being
added and removed as expected. 

### Verifying ALB Distributes Traffic Across Instances

1. **Access the ALB:** use the public dns name of the ALB to access the web server multiple times. 

`curl http://<ALB_DNS_NAME>`

2. **Check Logs:** Check the web server logs on each EC2 instance to verify that traffic is being
distributed across multiple instances.

3. **Health Checks:** Ensure that the ALB health checks are correctly configured and that unhealthy
instances are being marked as such. 

### Checking RDS instance Accessibility

1. **Connect from EC2:** SSH into one of the EC2 instances and attempt to connect to the RDS
instance using the database client (e.g, psql for PostgreSQL). Ensure the EC2 SG has the
right permissions for you to SSH into it. 

`ssh -i <your-key.pem> ec2-user@<EC2_INSTANCE_PUBLIC_IP>`
`psql -h <RDS_ENDPOINT> -U <DB_USER> -d <DB_NAME>`

2. **Verify Connection:** Ensure that you can successfully connect to the RDS instance and
perform basic database operations. 

3. **Check Security Groups:** Verify that the security group rules for the RDS instance only
allow access from the EC2 instances and not from the internet. 

4. **Test Internet Access:** Attempt to connect to the RDS instance from an external machine
to ensure that it is not accessible from the internet. 

### Ensuring Static Assets are correctly stored and accessible from S3

1. **Upload Assets:** Upload a test file to the s3 bucket. 

`aws s3 cp test-file.txt s3://<BUCKET_NAME>/`

2. **Verify public access:** Access the uploaded file via the public URL to ensure it is publicly
accessible. 

`curl http://<BUCKET_NAME>.s3.amazonaws.com/test-file.txt`

3. **Check Bucket Policies:** Verify that the bucket policies and ACLs are correctly configured to
allow public read access while restricting other access types. 

4. **Test Versioning:** If versioning is enabled, upload a new version of the test file and verify that
the previous version is still accessible. 

`aws s3 cp new-test-file.txt s3://<BUCKET_NAME>/test-file.txt`
`aws s3api list-object-versions --bucket <BUCKET_NAME> --prefix test-file.txt`

5. **Check Lifecycle Policies:** Verify that lifecycle policies are correctly managing old versions of files
and optimizing storage costs.
