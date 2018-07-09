FROM alpine

ADD rootfs /

ADD ./ /charts

WORKDIR /charts

ENV CURRENT_REPO_URL=

## Do not pack charts inside of container until this bug would be solved
## https://github.com/moby/moby/issues/22260
## https://github.com/kubernetes/helm/blob/master/pkg/downloader/manager.go#L220

EXPOSE 8879

ENTRYPOINT ["sh", "-c"]

CMD ["/init.sh"]
