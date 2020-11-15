FROM python:3.8.5-alpine3.12
COPY index.html /opt/python-server/index.html
EXPOSE 8000
ENTRYPOINT ["python", "-m", "http.server", "8000", "--directory", "/opt/python-server/"]
