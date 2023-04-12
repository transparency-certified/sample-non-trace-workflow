#!/bin/bash
source tools/parse_yaml.sh

eval $(parse_yaml config.yml)

repo=$(echo "${PWD##*/}" | tr [A-Z] [a-z])

TAG=${docker_rel:-latest}
MYHUBID=${docker_id:-larsvilhuber}
MYIMG=${docker_img:-$repo}

export DOCKERIMG=$MYHUBID/$MYIMG:$TAG
export TARGETID=run-$(uuidgen)

DOCKER_BUILDKIT=1 docker build \
  --build-arg DOCKERIMG=$DOCKERIMG \
   . \
  -t $TARGETID

echo $TARGETID
