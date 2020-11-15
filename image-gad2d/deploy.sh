#!/bin/bash
set -e
REGISTRY=docker.pkg.github.com
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PWD=$(pwd)
SECRETS=$VOL_SECRETS
NAME=$1
COMPOSE_FILE=$2
TAGREGEX=$3
echo "script file dir: $DIR"
echo "execution dir: $PWD"
echo "compose file: $COMPOSE_FILE"

export $(cat $SECRETS/docker-compose.env | grep -v "^#\|^$" | xargs)
#export COMMIT=$(git rev-parse HEAD)
export TAG=$($DIR/docker-tag.sh $(git tag -l --points-at HEAD | grep ${TAGREGEX} | head -n1))
echo "TAG: $TAG"
docker-compose -f $COMPOSE_FILE config \
               > $DIR/docker-compose.result.yaml

cat $SECRETS/registry-password.txt | \
    docker login --password-stdin --username $REGISTRY_LOGIN $REGISTRY
docker stack deploy --with-registry-auth \
    --prune \
    -c $DIR/docker-compose.result.yaml \
    $NAME
docker logout $REGISTRY
