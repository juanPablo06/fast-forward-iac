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
