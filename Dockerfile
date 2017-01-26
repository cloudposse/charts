FROM alpine

ADD ./ /opt/charts

WORKDIR /opt/charts

ENV CURRENT_REPO_URL=

RUN set -ex \
      && apk update \
      && apk add --no-cache --virtual .build-deps \
    	    curl \
    			git \
    			make \
    			bash \
    	&& make init \
    	&& make helm:install \
    	&& make helm:repo:add_remote \
      && make helm:repo:build REPO_PATH=incubator \
      && make helm:repo:build REPO_PATH=stable \
      && apk del .build-deps;

EXPOSE 8879

ENTRYPOINT ["make"]

CMD ["helm:serve"]
