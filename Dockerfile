# syntax=docker.io/docker/dockerfile:1
# vim:set ft=dockerfile:

# Q: Couldn't these RUN commands be merged?
# A: Yes, but this container is so large than the space saving is negligable
#    while the readability and caching is improved

FROM python:3.12-slim

LABEL org.opencontainers.image.authors="gary.brandon@gmail.com"
LABEL org.opencontainers.image.url="https://github.com/gazwald/cdk-docker"
LABEL org.opencontainers.image.title="CDK Docker"
LABEL org.opencontainers.image.description="AWS CDK base image for Python"

# Disable pip running as root message
ENV PIP_ROOT_USER_ACTION=ignore

ARG TARGETARCH
# renovate: datasource=pypi depName=aws-cdk-lib
ARG CDK_VERSION="2.103.0"
# renovate: datasource=github-tags depName=docker/cli
ARG DOCKER_VERSION="24.0.6"
# renovate: datasource=node-version
ARG NODE_VERSION="18.18.2"
# renovate: datasource=pypi depName=pip
ARG PIP_VERSION="23.3.1"
# renovate: datasource=pypi depName=poetry
ARG POETRY_VERSION="1.6.1"

ARG AWS_URL_AMD="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
ARG AWS_URL_ARM="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
ARG AWS_PATH="/tmp/awscliv2.zip"

ARG DOCKER_URL_AMD="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz"
ARG DOCKER_URL_ARM="https://download.docker.com/linux/static/stable/aarch64/docker-$DOCKER_VERSION.tgz"
ARG DOCKER_PATH="/tmp/docker-$DOCKER_VERSION.tgz"

ARG NODE_URL_AMD="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"
ARG NODE_URL_ARM="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.xz"
ARG NODE_PATH="/tmp/node-v$NODE_VERSION.tar.xz"

#
# Install dependencies, and jq because it's small and useful
#
# Don't bother removing these afterwards if you're looking for a small container
# CDK, Docker, and Python dependencies are gigabytes and these are kilobytes.
#
# hadolint ignore=DL3008
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      unzip \
      xz-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


#
# Install poetry and upgrade pip
#
RUN python3 -m pip install \
      --no-cache-dir \
      --upgrade \
      "pip==$PIP_VERSION" \
      "poetry==$POETRY_VERSION"

#
# Install AWS CLI
#
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        export AWS_URL=$AWS_URL_ARM; \
    else \
        export AWS_URL=$AWS_URL_AMD; \
    fi \
 && curl --fail \
         --silent \
         --show-error \
         --location \
         --output $AWS_PATH \
         $AWS_URL \
 && unzip $AWS_PATH \
      -d /tmp \
 && /tmp/aws/install \
 && rm --recursive \
       --force \
         $AWS_PATH

#
# Install statically compiled Docker CLI
#
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        export DOCKER_URL=$DOCKER_URL_ARM; \
    else \
        export DOCKER_URL=$DOCKER_URL_AMD; \
    fi \
 && curl --fail \
         --silent \
         --show-error \
         --location \
         --output $DOCKER_PATH \
         $DOCKER_URL \
 && tar --extract \
        --strip-components 1 \
        --file $DOCKER_PATH \
        --directory /usr/bin \
        docker/docker \
 && rm --recursive \
       --force \
         $DOCKER_PATH

#
# Install NodeJS
#
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        export NODE_URL=$NODE_URL_ARM; \
    else \
        export NODE_URL=$NODE_URL_AMD; \
    fi \
 && curl --fail \
         --silent \
         --show-error \
         --location \
         --output $NODE_PATH \
         $NODE_URL \
 && tar --extract \
        --strip-components 1 \
        --file $NODE_PATH \
        --directory /usr \
 && rm --recursive \
       --force \
         $NODE_PATH

#
# Install AWS CDK CLI
#
RUN npm --global install aws-cdk@$CDK_VERSION

ENTRYPOINT [ "cdk" ]
