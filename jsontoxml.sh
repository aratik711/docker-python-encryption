#!/bin/bash

set -e

##### VARIABLES TO BE EDITED #################

HOST_NAME=35.229.78.47
HOST_USERNAME=root
HOST_PASSWORD="root@123"
FILE_PATH="/root/files"
ENCRYPT_PASSWORD="mypassword"
IMAGE_NAME=aratik711/django:2.2
PORT=8000

install() {

if [ -z "$HOST_NAME" ] || [ -z "$HOST_USERNAME" ] || [ -z "$HOST_PASSWORD" ] || \
   [ -z "$FILE_PATH" ] || [ -z "$ENCRYPT_PASSWORD" ] || [ -z "$IMAGE_NAME" ] || \
   [ -z "$PORT" ]; then

  echo 'ERROR: one or more variables are undefined'
  exit 1

fi

if [ ! -d ${FILE_PATH} ]; then

  echo "Directory $FILE_PATH does not exist. Creating..."
  mkdir -p ${FILE_PATH}

fi

docker build --build-arg HOST_NAME=${HOST_NAME} --build-arg HOST_USERNAME=${HOST_USERNAME} \
--build-arg HOST_PASSWORD=${HOST_PASSWORD} \
--build-arg FILE_PATH=${FILE_PATH} \
--build-arg ENCRYPT_PASSWORD=${ENCRYPT_PASSWORD} \
-t ${IMAGE_NAME} -f Dockerfile .

docker run --name django-server -p ${PORT}:8000 -v ${FILE_PATH}:/opt/git_ranger/media -d ${IMAGE_NAME}

}

cleanup() {

printf "\n"
read -p "Do you want to delete the deployments (y/n)? " yn
case $yn in
   [Yy]* ) docker rm -f django-server
           echo "The deployments have been deleted"
           break;;
   * ) exit;;
esac

}

if ! command -v docker >/dev/null; then

  echo 'Please install docker'
  exit 1

else

  "$@"

fi