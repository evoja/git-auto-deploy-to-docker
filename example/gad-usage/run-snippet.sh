docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ./config.json:/app/config.json \
    -v ./ssh-config:/app/ssh-config \
    -v gad-secrets:/creds/secrets \
    -v gad-keys:/creds/keys \
    # Or:
    # -v gad-creds:/creds \
    --userns=host \
    --expose 8080 \
    -p 9000:8080 \
    --restart=always \
    docker.pkg.github.com/evoja/git-auto-deploy-to-docker/gad2d:gad2d-0.01
