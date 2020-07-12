FROM alpine:latest
LABEL maintainer="Ivan Elfimov <ielfimov@gmail.com>"
ENV HUGO_VERSION 0.73.0

RUN apk add --no-cache \
    curl \
    git \
    nodejs \
    npm \
    openssh-client \
    rsync \
    && mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && curl -L https://bin.equinox.io/c/dhgbqpS8Bvy/minify-stable-linux-amd64.tgz | tar -xz \
    && mv minify /usr/local/bin/ \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

WORKDIR /src
EXPOSE 1313
