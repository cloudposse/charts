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
    	&& make helm:add_repo \
      && make helm:clean helm:fix-perms helm:lint helm:package helm:index \
      && apk del .build-deps;


ENTRYPOINT ["helm"]
