FROM node:alpine as base

RUN mkdir /app
WORKDIR /app

RUN apk add --update python3 python3-dev git jq docker

RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --upgrade pip

FROM base
RUN npm -g install aws-cdk@latest

COPY requirements.base.txt .
RUN pip install --upgrade -r requirements.base.txt

COPY requirements.cdk.txt .
RUN pip install --upgrade -r requirements.cdk.txt

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
