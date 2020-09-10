FROM alpine:latest

RUN apk update
RUN apk add openssh

WORKDIR /usr/local/tunnel
COPY ./tunnel.sh ./tunnel.sh

ENTRYPOINT /usr/local/tunnel/tunnel.sh