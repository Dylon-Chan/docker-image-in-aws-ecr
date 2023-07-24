# Docker Image in AWS Elastic Container Registry (ECR)

This repository houses a straightforward Python Flask application. The application responds with a "Hello World" message and the elapsed time since the application started. The application is containerized using Docker and is designed to be deployed on the AWS Elastic Container Registry (ECR).

## Table of Contents
- [Files](#files)
- [Prerequisites](#prerequisites)
- [How to Build and Push Docker Image to AWS ECR](#how-to-build-and-push-docker-image-to-aws-ecr)
    - [Creating private repository in AWS ECR](#creating-private-repository-in-aws-ecr)
    - [Authenticating & Authorizing Docker to AWS ECR Repository](#authenticating--authorizing-docker-to-aws-ecr-repository)
    - [Building the Docker Image](#building-the-docker-image)
    - [Pushing Docker Image to your Private ECR](#pushing-docker-image-to-your-private-ecr)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)
- [Conclusion](#conclusion)

## Files
The repository consists of the following files:
- `helloworld.py`: A Python script that runs a Flask web server. This server responds to requests on the root path (`/`) with a "Hello World from Python!" message and the time elapsed since the server started.
- `Dockerfile`: This file is used to create a Docker image capable of running the Python script.

## Prerequisites
To use this project, you will need:
- An AWS account
- AWS CLI V2 installed on your local machine
- AWS credentials configured locally, specifically the Access and Secret Access keys (Make sure your AWS IAM user has 'AmazonEC2ContainerRegistryPowerUser' or higher permissions) 
    - To set this up, run `aws configure` in your terminal or command prompt
- Docker installed on your local machine
- Docker Desktop launched before running Docker commands


## How to Build and Push Docker Image to AWS ECR

### Creating private repository in AWS ECR
1. Open the AWS Management Console and navigate to Amazon Elastic Container Registry.
2. Click "Create Repository" under the "Private" tab, provide your desired repository name and then scroll down to click "Create Repository" again. The other settings can be left as default.

![click-create-repository](https://github.com/Dylon-Chan/docker-image-in-aws-ecr/blob/main/photos/click-create-repository.png)

![provide-repo-name](https://github.com/Dylon-Chan/docker-image-in-aws-ecr/blob/main/photos/provide-repo-name.png)

3. Once the repository is created successfully, you should see your repository name under the "Private repositories" section.

![successfully-create-repository](https://github.com/Dylon-Chan/docker-image-in-aws-ecr/blob/main/photos/successfully-create-repo.png)

### Authenticating & Authorizing Docker to AWS ECR Repository
Before you can push an image to your ECR repository, you must authenticate Docker to your AWS ECR repository. Run the following command to receive an authentication token and authenticate Docker to the ECR. Note that the user permissions of `ecr:GetAuthorizationToken` are needed and the IAM Policy (AWS Managed Policy) of `AmazonEC2ContainerRegistryPowerUser` is required.
```sh
aws ecr get-login-password --region <region of your ECR repository> | docker login --username AWS --password-stdin <your aws account number>.dkr.ecr.<region of your ECR repository>.amazonaws.com
# for example:
# aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin <account number>.dkr.ecr.ap-southeast-1.amazonaws.com
```
Remember to replace `region of your ECR repository` and  `your aws account number` in the command with your own values.

### Building the Docker Image
1. Clone this repository to your local machine.
    ```sh
    git clone https://github.com/Dylon-Chan/docker-image-in-aws-ecr.git
    ```
2. Navigate to the directory containing the Dockerfile.
    ```sh
    cd docker-image-in-aws-ecr
    ```
3. Run the following command to build the Docker image with the name "helloworldapp". The `-t` flag tags the image and the `.` represents the current directory, which means that Docker will use the current directory and its contents as the build context. 
    ```sh
    docker build -t helloworldapp .
    ```
4. You can run the following command to list all images and you will see the `helloworldapp` image is built and its Image ID.
    ```sh
    docker image ls
    ```

### Pushing Docker Image to your Private ECR
1. Run the following command to tag the image with the ECR repository.
    ```sh
    docker tag <image_name>:<image_tag> <repository_url>:<image_tag>
    # for example:
    # docker tag helloworldapp:latest <account number>.dkr.ecr.ap-southeast-1.amazonaws.com/wengsiong-python-app:latest
    ```
2. After tagging the image, you can run the following command to push the image to the ECR repository.
    ```sh
    docker push <repository_url>:<image_tag>
    # for example:
    # docker push <account number>.dkr.ecr.ap-southeast-1.amazonaws.com/wengsiong-python-app:latest
    ```
3. Once the image is pushed successfully, you should see the image tag inside your ECR repository as shown in the example photo below.

![image-ecr](https://github.com/Dylon-Chan/docker-image-in-aws-ecr/blob/main/photos/image-push-to-ecr.png)

4. You can click into the image tag to get the details as shown in the example photo below.

![image-details-ecr](https://github.com/Dylon-Chan/docker-image-in-aws-ecr/blob/main/photos/image-details-in-ecr.png)

## Troubleshooting
If you encounter any issues when following these instructions, consider these common solutions:

1. "Docker command not found" or "aws command not found"
    - Solution: Make sure Docker and AWS CLI are properly installed and added to your system's PATH. If you installed Docker Desktop, make sure Docker Desktop is launched before running Docker commands.
2. "Access denied" when trying to push the Docker image to ECR
    - Check the AWS credentials are configured correctly and have the necessary permissions to push an image to ECR.

## Next Steps
Once the Docker image is pushed to ECR repository, you can pull the image for local testing, or use it in an AWS ECS task definition. Here are the basic commands for both:
- Pull the Docker image for local testing
    ```sh
    docker pull <repository_url>:<image_tag>
    # for example:
    # docker pull <account number>.dkr.ecr.ap-southeast-1.amazonaws.com/wengsiong-python-app:latest
    ```
- To use the Docker image in an ECS task definition, refer to the [ECS documentation on Creating a Task Definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html)

## Conclusion
This guide provides step-by-step instructions to build a Docker image from a Python Flask application and deploy it to the AWS Elastic Container Registry (ECR).