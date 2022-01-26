FROM node:alpine

RUN mkdir /app
WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apk \
  apk add --update python3 python3-dev git jq docker

RUN --mount=type=cache,target=/root/.cache/pip \
  python3 -m pip install --upgrade pip

COPY requirements.base.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
  python3 -m pip install --upgrade -r requirements.base.txt

COPY requirements.cdk.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
  python3 -m pip install --upgrade -r requirements.cdk.txt

RUN --mount=type=cache,target=/root/.npm \
  npm -g install aws-cdk@1.140.0

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
