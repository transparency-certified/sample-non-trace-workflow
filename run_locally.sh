#!/bin/bash
source tools/parse_yaml.sh

eval $(parse_yaml config.yml)

repo=$(echo "${PWD##*/}" | tr [A-Z] [a-z])

TAG=${docker_rel:-latest}
MYHUBID=${docker_id:-larsvilhuber}
MYIMG=${docker_img:-$repo}

DOCKERIMG=$MYHUBID/$MYIMG:$TAG

echo "================================"
echo "Running docker:"
set -ev

# When we are on Github Actions
if [[ $CI ]] 
then
   DOCKEROPTS="--rm"
else
   DOCKEROPTS="-it --rm"
fi

# ensure that the directories are writable by Docker
chmod a+rwX data 
[[ -d tables ]] || mkdir tables
chmod a+rwX tables
chmod a+rwX programs
chmod a+rx *sh

# Build the docker image. this might require network access!

TARGETID=$(./build.sh)

# Now run the code

time docker run $DOCKEROPTS \
  -v "$(pwd)":/home/rstudio \
  -w /home/rstudio \
  $TARGETID run.sh


