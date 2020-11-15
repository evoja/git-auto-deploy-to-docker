#!/bin/sh
docker volume create gad-secrets
docker volume create gad-keys
docker run --rm \
    -v $(pwd)/instance-specific:/from \
    # This is possible too:
    # -v $(pwd)/instance-specific/keys:/from/keys \
    # -v $(pwd)/instance-specific/secrets/:/from/secrets \
    -v gad-secrets:/to/secrets \
    -v gad-keys:/to/keys \
    # Or this way:
    # -v gad-creds:/to \
    --userns=host \
    docker.pkg.github.com/evoja/git-auto-deploy-to-docker/gad2d-init-secrets:init-secrets-0.01
