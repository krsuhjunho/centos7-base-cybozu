#!/bin/bash

#VAR
DOCKER_CONTAINER_NAME="centos7-base-cybozu"
CONTAINER_HOST_NAME="centos7-base-cybozu"
SSH_PORT=22458
HTTP_PORT=8013
BASE_IMAGE_NAME="ghcr.io/krsuhjunho/centos7-base-cybozu"
SERVER_IP=$(curl -s ifconfig.me)
PC_URL="cgi-bin/cbag/ag.cgi"
HTTP_BASE="http://"
TODAY=$(date "+%Y-%m-%d")
TIME_ZONE="Asia/Tokyo"
COMMIT_COMMENT="$2"
BUILD_OPTION="$1"
TAG_VER=$( ls /docker/centos7-base-cybozu/cbof* | awk -F 'cbof-' '{ print $2}'| awk -F '-linux.bin' '{ print $1}')

DOCKER_IMAGE_BUILD()
{
	docker build -t ${BASE_IMAGE_NAME} .
}

DOCKER_IMAGE_TAG()
{
	docker image tag ${BASE_IMAGE_NAME} ${BASE_IMAGE_NAME}:${TAG_VER}
}

DOCKER_IMAGE_PUSH()
{
	docker push ${BASE_IMAGE_NAME}
	docker push ${BASE_IMAGE_NAME}:${TAG_VER}
	docker rmi  ${BASE_IMAGE_NAME}:${TAG_VER}
}

GIT_COMMIT_PUSH()
{
	git add -u
	git commit -a -m "${TODAY} ${COMMIT_COMMENT}"
	git config credential.helper store
	git push origin main
}

DOCKER_CONTAINER_REMOVE()
{
	docker rm -f ${DOCKER_CONTAINER_NAME}
}

DOCKER_CONTAINER_CREATE()
{
	docker run -tid --privileged=true \
	-h "${CONTAINER_HOST_NAME}" \
	--name="${DOCKER_CONTAINER_NAME}" \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-e TZ=${TIME_ZONE} \
	-p ${SSH_PORT}:22 -p ${HTTP_PORT}:80 \
	${BASE_IMAGE_NAME}

}

DOCKER_CONTAINER_BASH()
{
	docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash /var/www/cbof-10.8.5-linux.bin
}

DOCKER_CONTAINER_URL_SHOW()
{
	echo ""
	echo "CYBOZU URL => ${HTTP_BASE}${SERVER_IP}:${HTTP_PORT}/${PC_URL}"
	echo ""
}

MAIN()
{

	if [ "$BUILD_OPTION" == "--build" ]; then
		DOCKER_IMAGE_BUILD
		DOCKER_IMAGE_TAG		
		DOCKER_IMAGE_PUSH
		GIT_COMMIT_PUSH
	fi

	DOCKER_CONTAINER_REMOVE
	DOCKER_CONTAINER_CREATE
	DOCKER_CONTAINER_BASH
	DOCKER_CONTAINER_URL_SHOW
}

MAIN







