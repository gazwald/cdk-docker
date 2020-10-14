# Docker based CDK Python environment

## Configuration

Assumes you have either of the following; in order of preference:

### Environment variables

Will attempt to populate the container with the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `GIT_AUTHOR_NAME`
- `GIT_AUTHOR_EMAIL`
- `GIT_COMMITTER_NAME`
- `GIT_COMMITTER_EMAIL`

If these are not set the script will attempt to pull them from configuration files.

### Configuration files

Pulls first key from the following files:

- `~/.aws/credentials`
- `~/.aws/config`
- `~/.gitconfig`


## Confirming it all works

```bash
./cdk doctor
```

Should output something like this:
```
Using CDK image created "29 minutes ago".
ℹ️ CDK Version: 1.63.0 (build 7a68125)
ℹ️ AWS environment variables:
  - AWS_SECRET_ACCESS_KEY = <redacted>
  - AWS_DEFAULT_REGION = ap-southeast-2
  - AWS_ACCESS_KEY_ID = AKIA<redacted>
  - AWS_STS_REGIONAL_ENDPOINTS = regional
  - AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
ℹ️ No CDK environment variables
```

## Docker, Lambda, and Bundling

If you're using `core.BundlingOptions` then you'll need to start a Docker daemon (Podman in my case) that the CDK container can access to perform these task(s).

Example podman daemon:

```bash
podman system service --timeout 0 tcp:0.0.0.0:9000 &
```
