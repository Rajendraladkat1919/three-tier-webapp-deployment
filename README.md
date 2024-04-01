Deploy three tier web application using terraform

`What it is ?`

- This project contains DevOps tools and technologies which helps to deploy the end-to-end web application on EKS cluster.

Problem statement:

As a DevOps engineer I want do below things:

 1. Containerze the webapplication.
 2. Deploy the web application on container platform.


`Something we can think of`

Few approaches:

We can deploy the web application using multiple approaches. Its totally depend's on what type of web application it is and whats the actual requirements?. Below are the few solution we can think of while deploying it to cloud platform.

1. Serverless technologies
2. public hosted compute solution
3. ECS
4. EKS (fragate/ec2 bases hosting)
5. S3 buckets
6. Web hosted solution provider by cloud vendor.

Our Current approach:

To solve above problem statement we are taking below approach. 
We provising the EKS cluster with node group using eks module and deploying the wep application using helm manifest.

1. Infrastrcture related approach

   We are using the terraform to provision the infrastrcture for this projects.

2. Application related approach

    We are using existing application code which need to be dockerize.


Implementation details:


1. Current Tech Stack
    
    - Terraform - Provision the infrastructure for the web application
    - AWS - cloud platform where application is deployed
    - Jenkins - This is used as build and deploy tools. We are using Jenkins for build the docker images, helm zips and terraform deployments.
    - Kubectl & eksctl -connect with k8s API server.
    - nodejs application framework.
    - MongoDB databse
    - Grafana and prometheus- monitoring infratsructure amd application.

2. Deployment Diagram

3. Steps to Deploy application


** Best practices to productionze this application **

IAC and Source code management
Build Process
Deployment Process
Observability
monitoring, logging,alerting for infrastructure and application.
Operational Excellence
Security of infratsructure and application
Platform scalaibility and HA
Testing of infrastructure and application
Cost of overall operation.





** Future RoadMap **