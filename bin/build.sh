#!/bin/bash

# Build the image
docker build --progress plain -f ./build/Dockerfile \
    -t nitelite-pipeline:latest --platform linux/amd64 "$@" .

# # Log in to AWS
# aws ecr-public get-login-password --region us-east-1 | \
#     docker login --username AWS --password-stdin public.ecr.aws/i2m6n0b5
# 
# # Tag the image
# docker tag nitelite-pipeline:latest \
#     public.ecr.aws/i2m6n0b5/nitelite-pipeline:latest
# 
# # Push the image
# docker push public.ecr.aws/i2m6n0b5/nitelite-pipeline:latest