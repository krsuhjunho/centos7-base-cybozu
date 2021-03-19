#!/bin/bash

DOCKER_CONTAINER_NAME="cybozu-test"
CONTAINER_HOST_NAME="cybozu-test"
SSH_PORT=22458
HTTP_PORT=8013
BASE_IMAGE_NAME="ghcr.io/krsuhjunho/centos7-base-cybozu"
SERVER_IP=$(curl -s ifconfig.me)
PC_URL="cgi-bin/cbag/ag.cgi"
HTTP_BASE="http://"
TODAY=$(date "+%Y-%m-%d")
Comment="$1"

docker build -t ${BASE_IMAGE_NAME} .

docker push ${BASE_IMAGE_NAME}

git add .
git commit -m "${TODAY} ${Comment}"
git push origin main

docker rm -f ${DOCKER_CONTAINER_NAME}

docker run -tid --privileged=true \
-h "${CONTAINER_HOST_NAME}" \
--name="${DOCKER_CONTAINER_NAME}" \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-v /etc/localtime:/etc/localtime:ro \
-e TZ=Asia/Tokyo \
-p ${SSH_PORT}:22 -p ${HTTP_PORT}:80 \
${BASE_IMAGE_NAME}


docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash /var/www/cbof-10.8.5-linux.bin

echo ""
echo "CYBOZU URL => ${HTTP_BASE}${SERVER_IP}:${HTTP_PORT}/${PC_URL}"
echo ""

