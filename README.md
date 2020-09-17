# Docker based CDK Python environment

## Configuration

Assumes you have either of the following; in order of preference:

### Environment

Will attempt to populate the container with the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `GIT_AUTHOR_NAME`
- `GIT_AUTHOR_EMAIL`
- `GIT_COMMITTER_NAME`
- `GIT_COMMITTER_EMAIL`

If these are not set the script will attempt to pull them from configuration files.

### Configuration

Pulls first key from the following files:

- `~/.aws/credentials`
- `~/.aws/config`
- `~/.gitconfig`


## Confirming it all works

```bash
./cdk doctor
```
