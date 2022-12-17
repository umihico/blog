#!/bin/bash
set -euoxv pipefail

cd "$(dirname $0)"
cd ..

docker build -t ${GITHUB_REPOSITORY_NAME}/act-executor:latest -f scripts/act.Dockerfile .

act \
  -P ubuntu-latest=${GITHUB_REPOSITORY_NAME}/act-executor:latest \
  --secret ACT_ARCH=$(uname -m) \
  --secret AWS_ACCESS_KEY_ID \
  --secret AWS_SECRET_ACCESS_KEY \
  --secret AWS_SESSION_TOKEN \
  $(sed -e 's/^/--secret /' .env.secrets | cut -f1 -d= | tr '\n' ' ') \
  ${@:1}
