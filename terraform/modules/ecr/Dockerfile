FROM --platform=linux/amd64 python:3.10.2-alpine3.15

RUN apk update && \
  apk add --update alpine-sdk terraform nodejs npm && \
  pip install awscli && \
  curl -OL https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.0/terragrunt_linux_amd64 && \
  mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
  chmod +x /usr/local/bin/terragrunt