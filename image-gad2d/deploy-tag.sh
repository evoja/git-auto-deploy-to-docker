#!/bin/bash
set -e
echo "### Setting up some values"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PWD=$(pwd)
SECRETS=$VOL_SECRETS

function help {
    echo "/app/deploy-tag.sh [opts] <compose-yaml> <tag-regex>"
    echo "Options:"
    echo "    -n   docker stack name, default: repo directory name"
    echo "    -r   docker registry, default: docker.pkg.github.com"
    echo "    -s   sleep before start timeout, default: 5s"
    echo "    -h   this help"
}

while getopts ":r:s:n:h" opt; do
    case ${opt} in
        h ) help
            exit 0
            ;;
        s ) SLEEP_BEFORE_START=$OPTARG
            ;;
        n ) NAME=$OPTARG
            ;;
        r ) REGISTRY=$OPTARG
            ;;
        \? ) help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

REGISTRY=${REGISTRY:-docker.pkg.github.com}
SLEEP_BEFORE_START=${SLEEP_BEFORE_START:-5s}
NAME=${NAME:-$(basename ${PWD})}
COMPOSE_FILE=$1
TAGREGEX=$2
echo "Script file dir: $DIR"
echo "Execution dir: $PWD"
echo "Docker registry: $REGISTRY"
echo "Compose file: $COMPOSE_FILE"
echo "Stack name: $NAME"

export $(cat $SECRETS/docker-compose.env | grep -v "^#\|^$" | xargs)
#export COMMIT=$(git rev-parse HEAD)
export TAG=$($DIR/docker-tag.sh $(git tag -l --points-at HEAD | grep -E "${TAGREGEX}" | head -n1))
echo "TAG: $TAG"
docker-compose -f $COMPOSE_FILE config \
               > $DIR/docker-compose.result.yaml

cat $SECRETS/registry-password.txt | \
    docker login --password-stdin --username $REGISTRY_LOGIN $REGISTRY
echo "### Trying to remove stack $NAME"
docker stack rm $NAME
echo "### Sleeping for $SLEEP_BEFORE_START"
sleep $SLEEP_BEFORE_START & wait ${!}
echo "### Deploying stack $NAME"
docker stack deploy --with-registry-auth \
    --prune \
    -c $DIR/docker-compose.result.yaml \
    $NAME
docker logout $REGISTRY
