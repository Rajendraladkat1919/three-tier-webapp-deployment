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
    - Currently role uses admin permisison to create eks cluster which need to be assign with Least Privilege.
    
# Application Deployment Workflow CI/CD in real time.

    1. Developer push the code into application repository.
    2. Once code is pushed into repository automated pipleine will be trigger to create the docker images from this code.
    3. This docker images pushed to docker artifactory nexus,ECR, artifactort etc.
    4. After this once final docker image is certified by QA team, respective docker image tag pushed inside helm chart.
    5. After this helm chart will be release as a artifact inside the artifactory using Jenkins pipeline.
    6.We can use either GitOps/ Jenkins pipeline to deploy this code on EKS cluster.
    7. Observe the application using Grafana dashboard.
    8. Logs will be colleted inside Cloudwatch.

# Deployment steps:

    Please note that we are creating one role with admin access to run below projects. This role has admin permisison for now in real production least privillges principle used to create role and run this projects.
    Also user who run this or assuming above role should have necessary permission in real world.
    For demo purpose we just created one user/role with admin access and exposrting its key locally on command line to run this terraform code.

     - Prerequisite

        Please make sure we have export your key locally before running this terraform code. Below page helps to understand how authenticate terraform with aws provider.

        [! https://registry.terraform.io/providers/hashicorp/aws/latest/docs?product_intent=terraform#environment-variables]
    
        1. Install Kubectl https://kubernetes.io/docs/tasks/tools/

        2. Install Helm https://helm.sh/docs/intro/install/

        3. Install aws-cli https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

        4. create service role to perform the deployment.


    1. infrastructure provisioning:

        Go to the infratructure folder. Each folder you need to run terraform command.
        
        `terraform apply auto-approve`. The workflow to run this terraform command is as below.

        1. aws-backend-state : Provide the backend bucket name inside main.tf file and run the terraform code using terraform apply. Pleasem make sure backend bucket created in advance before running this code.

        2. aws-networking : VPC module used to create network for EKS cluster.

        3. eks-essentials: create the EKS cluster with autoscaling functionality.

        4. monitoring - this folder setup the prometheus and grafana.

    
    
    2.  Deployment using local machine or from the aws cloud instance or aws cloud9.
        
        Make sure backend and frontened images available inside ECR repo or artifactorty of your choice. After that before deploying both the images make sure MongoDB available in place.

    - Buid Docker images :

    
        - For Mac:

        ```
        export DOCKER_CLI_EXPERIMENTAL=enabled
        aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/xxxxxxxx
        ```
        Buid Front End :
        
        '''
        docker buildx build --platform linux/amd64 -t workshop-frontend:v1 . 
        docker tag workshop-frontend:v1 public.ecr.aws/xxxxxxxx/workshop-frontend:v1
        docker push public.ecr.aws/xxxxxxxx/workshop-frontend:v1
        '''
        Buid Back End :
        
        '''
        docker buildx build --platform linux/amd64 -t workshop-backend:v1 . 
        docker tag workshop-backend:v1 public.ecr.aws/xxxxxxxx/workshop-backend:v1
        docker push public.ecr.aws/xxxxxxxx/workshop-backend:v1

        # For Linux/Windows:

        a. Buid Front End :

        ```
        docker build -t workshop-frontend:v1 . 
        docker tag workshop-frontend:v1 public.ecr.aws/xxxxxxxx/workshop-frontend:v1
        docker push public.ecr.aws/xxxxxxxx/workshop-frontend:v1
        ```
        b. Buid Back End :

        ```
        docker build -t workshop-backend:v1 . 
        docker tag workshop-backend:v1 public.ecr.aws/xxxxxxxx/workshop-backend:v1
        docker push public.ecr.aws/xxxxxxxx/workshop-backend:v1
        ```

    - Update Kubeconfig Syntax: 
    
        ```
        aws eks update-kubeconfig --region region-code --name your-cluster-name
    
        ```
    - Create Namespace before deploying to EKS

        '''
        kubectl create ns webapp-demo
        kubectl config set-context --current --namespace webapp-demo

        '''

    - MongoDB Database Setup

        To create MongoDB Resources
        '''
        cd k8s_manifests/mongo_v1
        - kubectl apply -f secrets.yaml
        - kubectl apply -f deploy.yaml
        - kubectl apply -f service.yaml
        '''
        
        Backend API Setup

        Create NodeJs API deployment by running the following command:

        '''
        - kubectl apply -f backend-deployment.yaml
        - kubectl apply -f backend-service.yaml
        '''
        
        Frontend setup

        To create the frontend  resource inside terminal run the following command:
        '''
        - kubectl apply -f frontend-deployment.yaml
        - kubectl apply -f frontend-service.yaml
        '''
        Finally create the final load balancer to allow internet traffic:

        kubectl apply -f full_stack_lb.yaml

## Best practices to productionze this application

1. IAC and Source code management
    - central secret manager
    - module wise remote state managment.
    - auotomated infra creation pipeline.
    - Application configuration management.
    - Git branching stratergy.
    - infrastrcture code contains below tools while developing infrastrcture code.
        
        checkov (deprecated) and terraform_checkov
        infracost_breakdown
        terraform_docs
        terraform_docs_replace (deprecated)
        terraform_fmt
        terraform_providers_lock
        terraform_tflint
        terraform_tfsec (deprecated)
        terraform_trivy
        terraform_validate
        terraform_wrapper_module_for_each
        terrascan
        tfupdate
    All the above tools are part of pre-commit hooks or part of stages when we develp code.

2. Build Process
   
    - we can use the Left shift security approach to build indrastrcture and docker images.
    - We create vulnerabilities scan pipeline for docker images , libraries or any packages download from the internet.
    - Dashboard for  Jenkins build jobs to provide overall overview of build server. 
    
3. Deployment Process

    - Identical build & deploy process across all env.
    - Auotomated application versioning and conventional commits.
    - Left shift security approach to all pipelines.
    - Deployment stratergies along with rollback feature should be in place.

4. Observability
   
   This includes monitoring, logging,alerting for infrastructure and application.
    - Better application and infratsrcture logs management.
    - Grafana dashboard for application and infrastructure managements.
    - Log encryption and log retention mechanism.
    - All the key Matrics, Logs & Traces are captured properly.

5. Operational Excellence 
    
    This includes DR,IR,RTO,RPO and overall production run cost.

6. Security of infratsructure and application

    This includes 
    - developing secure code
    - autherization and authentication of infratsrcture
    - create vulnerabilities, CVE free artifacts
    - encryption of data
    - securing E2E request
    - certificate management
    - secret management
    - hardning of compute resources etc.

7. Platform scalaibility and HA :

    - To achive seamless scalability & High availability architecture should be design in such way that it shoule be scalable and available as per the SLO/SLA.

8. Testing of infrastructure and application:

    following test should be in place for application and infratsrcture.

    - System Testing
    - Functional Testing
    - Acceptance Testing
    - Smoke Testing
    - Regression Testing
    - Performance Testing
    - Load Testing

9. Cost of overall operation:

    Security & cost are the most important factor while running any business these days. In order to control the operational cost it will good to have cost optimization stratergy in place to achive better result.
    From day 0 we should have security in place.

## Future Roadmap

Software architecture is trade-off. This architecture or system design for software evolve day by day. Its continious process. In the current simple demo application we can think of few ideas.

- create infrastrcture as seprate module.
    1. Project should first contain networking layer module
    2. we have all role and its permission module for application & infra layer module
    3. Restricted permission assign to above netowrking module where least privelliges and strict permission given to each role and users.
    4. All secrets should be consumed through AWS secret manager or central secret manager like hashicorp
    5. All certifacte should be managed using ACM
    6. Jenkins will be used with Left Shift aprroach to build docker and helm as artifacts.
    7. Automated Jenkis pipeline will be in place to provision infratsructure and deploy the application code.
    8. We can replace the database with Managed database as per the requirement where less operation cost is requires.