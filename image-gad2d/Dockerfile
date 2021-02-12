FROM docker.pkg.github.com/evoja/docker-git-auto-deploy/gitautodeploy-ch:dv-0.17-03
LABEL maintainer="Chivorotkiv <git@chiv.info>"

ENV DOCKER_GID=999
RUN apk add --no-cache --update docker docker-compose bash && \
    # originally in alpine "ping" has gid=999 that equals to "docker" gid in DigitalOcean ubuntu
    # change its gid to 998 to let "docker" group be 999
    delgroup ping && addgroup -g 998 ping && \
    delgroup docker && addgroup -g ${DOCKER_GID} docker && addgroup ${GAD_USER} docker && \
    rm -rf /var/cache/apk/*

ENV \
    VOL_KEYS=/creds/keys \
    VOL_SECRETS=/creds/secrets

COPY init.sh /home/gad/init.sh
COPY docker-tag.sh .
COPY deploy-tag.sh .
RUN \
    chown -R $GAD_USER:$GAD_USER . && \
    chown $GAD_USER:$GAD_USER ./deploy-tag.sh /home/gad/init.sh
USER $GAD_USER
