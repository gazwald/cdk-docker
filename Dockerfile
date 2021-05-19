FROM node:alpine as base

RUN mkdir /app
WORKDIR /app

RUN apk add --update python3 python3-dev git jq docker

RUN python3 -m pip install --upgrade pip

FROM base

COPY requirements.base.txt .
RUN python3 -m pip install --upgrade -r requirements.base.txt

COPY requirements.cdk.txt .
RUN python3 -m pip install --upgrade -r requirements.cdk.txt

RUN npm -g install aws-cdk@latest

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
