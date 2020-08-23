FROM node:alpine

ARG email="you@example.com
ARG name="Your Name"

RUN mkdir /app
WORKDIR /app

RUN apk add --update python3 python3-dev git jq

RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --upgrade pip
RUN pip install boto3 json-spec yamllint
RUN npm install -g aws-cdk
RUN pip install --upgrade \
  awscli \
  aws-cdk.aws_apigateway \
  aws-cdk.aws_ec2 \
  aws_cdk.aws_ecs \
  aws_cdk.aws_certificatemanager \
  aws_cdk.aws_s3 \
  aws_cdk.aws_s3_deployment \
  aws_cdk.aws_cloudfront \
  aws_cdk.aws_route53 \
  aws_cdk.aws_route53_targets

RUN git config --global user.email $email
RUN git config --global user.name $name

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
