# hugo-node-builder

This is a simple Hugo website builder. It includes all necessary tools for me to build Hugo websites I manage.

The idea was taken from [jguyomard/docker-hugo](https://github.com/jguyomard/docker-hugo). I just added `node` and `npm` as well as merged two `RUN` statements to make even smaller image size.

## How to use with Drone

You will need to add these secrets:

- `SSH_PRIVATE_KEY` - ex. `cat ~/.ssh/id_rsa | pbcopy`
- `SSH_PORT` - ex. `2222`, because you shouldn't use `22`
- `SSH_HOSTDEST` - ex. `myuser@1.2.3.4:/var/www/hugosite`

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: deploy
  image: biozz/hugo-node-builder:latest
  environment:
    BUILD_DIR: "/tmp/build"
    SSH_PRIVATE_KEY:
      from_secret: SSH_PRIVATE_KEY
    SSH_PORT:
      from_secret: SSH_PORT
    SSH_HOSTDEST:
      from_secret: SSH_HOSTDEST
  commands:
  - npm install
  - eval `ssh-agent -s`
  - echo "$SSH_PRIVATE_KEY" | ssh-add /dev/stdin
  # For Docker builds disable host key checking - http://doc.gitlab.com/ce/ci/ssh_keys/README.html
  - mkdir -p ~/.ssh
  - echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
  - hugo --destination "$BUILD_DIR"
  - rsync -rv -e "ssh -p $SSH_PORT" "$BUILD_DIR"/ "$SSH_HOSTDEST" --checksum
  when:
    branch:
    - master
```
