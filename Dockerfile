FROM python:3.10

RUN mkdir /app
WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apt \
  apt update && \
  apt upgrade -y

RUN --mount=type=cache,target=/var/cache/apt \
  apt install -y git jq docker npm

RUN --mount=type=cache,target=/root/.cache/pip \
  python3 -m pip install --upgrade pip pip-tools

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
    && cd /tmp \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm /tmp/awscliv2.zip

# Install Python Dependencies
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
  python3 -m pip install --upgrade \
                         -r requirements.txt

# Install CDK
COPY package.json .
RUN --mount=type=cache,target=/root/.npm \
  npm -g install aws-cdk

ENTRYPOINT [ "cdk" ]
