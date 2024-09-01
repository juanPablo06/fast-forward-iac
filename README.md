# fast-forward-iac

## 1. Dockerfile/docker-compose

### Building and running the application

Build and run the application on detached mode using docker compose by running:
`docker compose up -d - -build`.

The application will be available at http://localhost:8080.

### Scaling considerations

For scaling the application using docker compose, you can add a --scale flag
to the `docker compose up` command and define how many replicas of the 
specific service you want to run (backend in our case). 
It can also be achieved declaratively by adding a replicas definition to docker-compose.yml:

`deploy:
        replicas: 3`

This creates another requirement: load balancing between the replicas. 
To solve this issue we can add a Reverse Proxy like NGINX to our docker-compose.yml. 

One of the challenges is that for deploying an application using Compose you'd have to run it on a single server. 
For proper orchestration of the application using Compose, we would have to run it on a Docker Swarm cluster.
