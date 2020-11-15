# Volume initializing image.
# It takes files from host folder (mounted as volume)
# and copies to the volume that is used in GAD container
# also it chowns files to be used by GAD user.

FROM docker.pkg.github.com/evoja/docker-git-auto-deploy/gitautodeploy-ch:dv-0.17-01 as users
LABEL maintainer="Chivorotkiv <git@chiv.info>"
ENTRYPOINT ["/app/init.sh"]
ENV \
    GAD_UID=1001 \
    GAD_GID=1001 \
    VOL_KEYS_FROM=/from/keys \
    VOL_KEYS_TO=/to/keys \
    VOL_SECRETS_FROM=/from/secrets \
    VOL_SECRETS_TO=/to/secrets
COPY init.sh /app/init.sh
