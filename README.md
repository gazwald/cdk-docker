# Docker based CDK Python environment

## Configuration

Most/all environment veriables and configuration options are passed in via sourcing the `env` file.

### AWS and Git

Assumes you have either of the following; in order of preference:

#### Environment variables

Will attempt to populate the container with the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `GIT_AUTHOR_NAME`
- `GIT_AUTHOR_EMAIL`
- `GIT_COMMITTER_NAME`
- `GIT_COMMITTER_EMAIL`

If these are not set the script will attempt to pull them from configuration files.

#### Configuration files

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

If you're using `core.BundlingOptions` then you'll need to start a Docker daemon that the CDK container can access to perform these task(s).

Either pass through the docker socket into the container by adding the following to the `run` command:
```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

or allow the access to the Docker daemon via TCP, for example:
```bash
sudo dockerd -H unix:///var/run/docker.sock -H tcp://$(hostname -i)
```

Note that the scripts within this repo currently assume that you'll be creating a TCP socket so adjust accordingly if you're binding the UNIX socket.

This will create the default Docker socket and a TCP socket for the CDK container to connect to.

No consideration has been made for security with this; it's all convenience.

On Mac OS X Docker is already running remotely in a local VM so you may just need to adjust the configuration in the `env` file.
