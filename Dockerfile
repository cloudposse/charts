FROM alpine

ADD rootfs /

ADD ./ /opt/charts

WORKDIR /opt/charts

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
    	&& make helm:repo:add_remote \
      && make helm:repo:build REPO_PATH=incubator \
      && make helm:repo:build REPO_PATH=stable ;

EXPOSE 8879

ENTRYPOINT ["sh", "-c"]

CMD ["/init.sh"]
