#!/bin/bash
IMAGENAME="app"
NAME="snojo"
SECOND="week1"


echo "Starting Docker Build"
docker build -t ${IMAGENAME} .
echo "Docker Build Finished"
# Get the commit id
COMMIT_ID=$(git rev-parse HEAD)
echo "COMMIT_ID=${COMMIT_ID}" > ./provisioning/.env

# Tag your docker image
docker tag ${IMAGENAME} ${NAME}/${SECOND}:${COMMIT_ID}
#docker tag ${IMAGENAME} ${NAME}/${SECOND}
# Push to docker hub
docker push ${NAME}/${SECOND}:${COMMIT_ID}
#docker push ${NAME}/${SECOND}
echo "Docker has been pushed"

