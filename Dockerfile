FROM alpine:latest

ARG DOCKER_GEN_VERSION="0.14.0"
ARG FOREGO_VERSION="0.16.1"
ARG CADDY_VERSION="latest"

ENV CADDYPATH="/etc/caddy"
ENV DOCKER_HOST="unix:///tmp/docker.sock"
ENV GOPATH="/go"
ENV GOBIN="/go/bin"

# Install minimal dependencies
RUN apk update && apk upgrade \
  && apk add --no-cache bash curl wget tar git \
    nss-tools ca-certificates \
  # Install Forego
  && wget --quiet "https://github.com/jwilder/forego/releases/download/v${FOREGO_VERSION}/forego" \
  && mv ./forego /usr/bin/forego \
  && chmod u+x /usr/bin/forego \
  # Install docker-gen
  && wget --quiet "https://github.com/nginx-proxy/docker-gen/releases/download/${DOCKER_GEN_VERSION}/docker-gen-alpine-linux-amd64-${DOCKER_GEN_VERSION}.tar.gz" \
  && tar -C /usr/bin -xvzf "docker-gen-alpine-linux-amd64-${DOCKER_GEN_VERSION}.tar.gz" \
  && rm "docker-gen-alpine-linux-amd64-${DOCKER_GEN_VERSION}.tar.gz" \
  # Install Go for xcaddy (temporary)
  && apk add --no-cache go make \
  # Install xcaddy and build Caddy with plugins
  && go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
  && $(go env GOBIN)/xcaddy build ${CADDY_VERSION} \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/ggicci/caddy-jwt \
  && mv caddy /usr/bin/caddy \
  && chmod u+x /usr/bin/caddy \
  # Clean up Go and build tools
  && apk del go make \
  && rm -rf /go /root/.cache /root/go

EXPOSE 80 443 2015
VOLUME /etc/caddy

# Starting app:
COPY . /code
COPY ./docker-gen/templates/Caddyfile.tmpl /code/docker-gen/templates/Caddyfile.bkp
WORKDIR /code

ENTRYPOINT ["sh", "/code/docker-entrypoint.sh"]
CMD ["/usr/bin/forego", "start", "-r"]
