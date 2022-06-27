After applying the docker deployment, do the following steps before applying the aws deployment:

To be able to push our new docker image to AWS ECR, use the following command to retrieve an authentication token and authenticate your Docker client to your registry.

aws ecr get-login-password --region <YOUR_REGION> | docker login --username AWS --password-stdin <YOUR_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_REGION>.amazonaws.com

Next, we will tag our local image:

tag <DOCKER_IMAGE_NAME> <YOUR_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_REGION>.amazonaws.com/<YOUR_ECR_REPO>:latest

Now we are able to push the tagged image to AWS ECR:

push <YOUR_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_REGION>.amazonaws.com/<YOUR_ECR_REPO>:latest
