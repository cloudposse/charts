FROM alpine

ADD ./ /opt/charts

WORKDIR /opt/charts

RUN set -ex \
      && apk update \
      && apk add --no-cache --virtual .build-deps \
    	    curl \
    			git \
    			make \
    			jq \
    			bash \
    	&& make init \
    	&& make helm:install \
    	&& make helm:repo:add_remote \
      && make helm:repo:build REPO_PATH=incubator \
      && make helm:repo:build REPO_PATH=stable \
      && apk del .build-deps;

ENTRYPOINT ["helm"]
