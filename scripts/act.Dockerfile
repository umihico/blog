FROM catthehacker/ubuntu:act-latest

# setup latest yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update

ARG TARGETARCH

# install aws cli v2
RUN if [ "$TARGETARCH" = "amd64" ]; then curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; fi; \
  if [ "$TARGETARCH" = "arm64" ]; then curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; fi; \
  unzip awscliv2.zip && \
  ./aws/install
