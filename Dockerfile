FROM alpine

ADD rootfs /

ADD ./ /charts

WORKDIR /charts

ENV CURRENT_REPO_URL=

RUN set -ex \
      && apk update \
      && apk add --no-cache \
          curl \
          git \
          make \
          bash \
      && make init \
      && make helm:install \
      && make helm:repo:add-remote \
      && make helm:repo:build REPO_NAME=incubator \
      && make helm:repo:build REPO_NAME=stable ;

EXPOSE 8879

ENTRYPOINT ["sh", "-c"]

CMD ["/init.sh"]
