#!/bin/bash
# IMAGENAME="tictactoe"
# NAME="snojo"
# SECOND="week1"


# echo "Starting Docker Build"
# docker build -t ${IMAGENAME} .
# echo "Docker Build Finished"
# Get the commit id
COMMIT_ID=$(git rev-parse HEAD)
echo "COMMIT_ID=${COMMIT_ID}" > ./provisioning/.env

# Tag your docker image
# docker tag ${IMAGENAME} ${NAME}/${SECOND}:${COMMIT_ID}
# #docker tag ${IMAGENAME} ${NAME}/${SECOND}
# # Push to docker hub
# docker push ${NAME}/${SECOND}:${COMMIT_ID}
# #docker push ${NAME}/${SECOND}
# echo "Docker has been pushed"

cp ./package.json ./build/
cp ./Dockerfile ./build/

cd build

echo Building docker image

docker build -t tictactoe snojo/week2:$GIT_COMMIT .

rc=$?
if [[ $rc != 0 ]] ; then
    echo "Docker build failed " $rc
    exit $rc
fi

docker push tictactoe snojo/week2:$GIT_COMMIT
rc=$?
if [[ $rc != 0 ]] ; then
   echo "Docker push failed " $rc
   exit $rc
fi


