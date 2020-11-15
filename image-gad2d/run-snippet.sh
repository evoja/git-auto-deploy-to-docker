docker run --rm \
    -v ./config.json:/app/config.json \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gad-secrets:/creds/secrets \
    -v gad-keys:/creds/keys \
    --userns=host \
    --expose 8080 \
    -p 8080:9000 \
    docker.pkg.github.com/evoja/git-auto-deploy-to-docker/gad2d:gad2d-0.01
