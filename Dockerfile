FROM node:alpine

RUN mkdir /app
WORKDIR /app

RUN apk add --update python3 python3-dev git jq docker

RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --upgrade pip
RUN pip install --upgrade -r requirements.base.txt
RUN npm install -g aws-cdk@latest
RUN pip install --upgrade -r requirements.cdk.txt

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
