#!/bin/bash
IMAGENAME="app"
NAME="snojo"
SECOND="week1"



docker build -t ${IMAGENAME} .

# Get the commit id
COMMIT_ID=$(git rev-parse HEAD)
echo "COMMIT_ID=${COMMIT_ID}" > .provisioning/.env

# Tag your docker image
docker tag ${IMAGENAME} ${NAME}/${SECOND}:${COMMIT_ID}
#docker tag ${IMAGENAME} ${NAME}/${SECOND}
# Push to docker hub
docker push ${NAME}/${SECOND}:${COMMIT_ID}
#docker push ${NAME}/${SECOND}

