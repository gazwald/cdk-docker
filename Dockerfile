FROM node:alpine

RUN mkdir /app
WORKDIR /app

RUN apk add --update python3 python3-dev git jq docker

RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --upgrade pip
RUN pip install --upgrade boto3 json-spec yamllint pyyaml
RUN npm install -g aws-cdk@latest
RUN pip install --upgrade \
  awscli \
  aws-cdk.aws_apigateway \
  aws-cdk.aws_apigatewayv2 \
  aws-cdk.aws_ec2 \
  aws_cdk.aws_ecs \
  aws_cdk.aws_rds \
  aws_cdk.aws_efs \
  aws_cdk.aws_certificatemanager \
  aws_cdk.aws_s3 \
  aws_cdk.aws_s3_deployment \
  aws_cdk.aws_cloudfront \
  aws_cdk.aws_route53 \
  aws_cdk.aws_route53_targets \
  aws_cdk.aws_lambda_event_sources \
  aws_cdk.aws_kms

ENTRYPOINT [ "/usr/local/bin/cdk" ]
CMD [ "help" ]
