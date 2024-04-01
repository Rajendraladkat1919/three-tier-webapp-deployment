# Deploy three tier web application using terraform

This project contains DevOps tools and technologies which helps to deploy the end-to-end web application on EKS cluster.

## A. Problem statement:

`What it is ?`

As a DevOps engineer I want do below things:

 1. Containerze the webapplication.
 2. Deploy the web application on container platform.

## B. Few approaches:

`Something we can think of`

We can deploy the web application using multiple approaches. Its totally depend's on what type of web application it is and whats the actual requirements?. Below are the few solution we can think of while deploying it to cloud platform.

1. Serverless technologies
2. public hosted compute solution
3. ECS
4. EKS (fragate/ec2 bases hosting)
5. S3 buckets
6. Web hosted solution provider by cloud vendor.

## C. Our Current approach:

To solve above problem statement we are taking below approach. We are provising the EKS cluster with node group using eks module and deploying the wep application using helm manifest.

1. Infrastrcture related approach

   We are using the terraform to provision the infrastrcture for this projects.

2. Application related approach

    We are using existing application code which need to be dockerize.


## D. Implementation details:


1. Current Tech Stack
    
    - Terraform - Provision the infrastructure for the web application
    - AWS - cloud platform where application is deployed
    - Jenkins - This is used as build and deploy tools. We are using Jenkins for build the docker images, helm zips and terraform deployments.
    - Kubectl & eksctl - Tools uses to connect with k8s API server.
    - Nodejs - frontend application framework.
    - MongoDB - we can use this as database.
    - Grafana and prometheus- monitoring infratsructure and application.

2. Deployment Diagram

    ![Alt text](Amazon-Elastic-Kubernetes-Service-EKS-Explained-Diagram-5.png)

3. Steps to Deploy application:

Please note that this is just simple demo appplication and it does not follow all the standard and best practicies.


    # Few Assumptions:

    - While deploying the code we can either use terraform from local machine or Jenkins job to create and deploy the application.
    - All the secrets and certificate requires for application & infrastructure need to be created upfront.
    - While deplying terraform code we can use role with resutricted permissions.
    - Database is ready before the application deployment.
    - we can use Jenkins server to build the docker image and helm chart.
    - To deploy application we can use helm deployment with Jenkins jobs.
    - All the access between Jenkins, EKS, Git sorted upfront.
    - There will be diffrent repo for application code and infratructure code.
    - Git branching and deployment stratergy decided upfront.
 
    # Application Deployment Workflow CI/CD in real time.

    1. Developer push the code into application repository.
    2. Once code is pushed into repository automated pipleine will be trigger to create the docker images from this code.
    3. This docker images pushed to docker artifactory nexus,ECR, artifactort etc.
    4. After this once final docker image is certified by QA team, respective docker image tag pushed inside helm chart.
    5. After this helm chart will be release as a artifact inside the artifactory using Jenkins pipeline.
    6.We can use either GitOps/ Jenkins pipeline to deploy this code on EKS cluster.
    7. Observe the application using Grafana dashboard.
    8. Logs will be colleted inside Cloudwatch.

    # Deploying steps:

    Deployment using local machine or from the aws cloud instance or aws cloud9.
    
    - Prerequisite
    
        1. Install Kubectl https://kubernetes.io/docs/tasks/tools/

        2. Install Helm https://helm.sh/docs/intro/install/

        3. Install aws-cli https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

        4. create service role to perform the deployment.

    - Buid Docker images :

    
        - For Mac:

        ```
        export DOCKER_CLI_EXPERIMENTAL=enabled
        aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/w8u5e4v2
        ```
        Buid Front End :
        
        '''
        docker buildx build --platform linux/amd64 -t workshop-frontend:v1 . 
        docker tag workshop-frontend:v1 public.ecr.aws/w8u5e4v2/workshop-frontend:v1
        docker push public.ecr.aws/w8u5e4v2/workshop-frontend:v1
        '''
        Buid Back End :
        
        '''
        docker buildx build --platform linux/amd64 -t workshop-backend:v1 . 
        docker tag workshop-backend:v1 public.ecr.aws/w8u5e4v2/workshop-backend:v1
        docker push public.ecr.aws/w8u5e4v2/workshop-backend:v1

        # For Linux/Windows:

        a. Buid Front End :

        ```
        docker build -t workshop-frontend:v1 . 
        docker tag workshop-frontend:v1 public.ecr.aws/w8u5e4v2/workshop-frontend:v1
        docker push public.ecr.aws/w8u5e4v2/workshop-frontend:v1
        ```
        b. Buid Back End :

        ```
        docker build -t workshop-backend:v1 . 
        docker tag workshop-backend:v1 public.ecr.aws/w8u5e4v2/workshop-backend:v1
        docker push public.ecr.aws/w8u5e4v2/workshop-backend:v1
        ```

    # Update Kubeconfig Syntax: 
    
    ```
    aws eks update-kubeconfig --region region-code --name your-cluster-name
    
    ```
    





## Best practices to productionze this application

1. IAC and Source code management
2. Build Process
3. Deployment Process
4. Observability
5. monitoring, logging,alerting for infrastructure and application.
6. Operational Excellence
7. Security of infratsructure and application
8. Platform scalaibility and HA
9. Testing of infrastructure and application
10. Cost of overall operation.

## Future Roadmap 