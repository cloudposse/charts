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
      && make helm:repo:clean \
      && make helm:repo:fix-perms \
      && make helm:repo:lint \
      && make helm:repo:package \
      && make helm:repo:index \
      && apk del .build-deps;

ENTRYPOINT ["helm"]
