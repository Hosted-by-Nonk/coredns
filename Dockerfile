FROM debian:stable-slim

RUN export DEBCONF_NONINTERACTIVE_SEEN=true \
           DEBIAN_FRONTEND=noninteractive \
           DEBIAN_PRIORITY=critical \
           TERM=linux; \
    apt-get -qq update \
    && apt-get -yyqq upgrade \
    && apt-get -yyqq install curl ca-certificates libcap2-bin \
    && apt-get clean

COPY --from=coredns/coredns:1.13.1 /coredns /coredns
RUN setcap cap_net_bind_service=+ep /coredns

HEALTHCHECK --interval=5s --timeout=5s --retries=1 \
    CMD curl -f localhost:${HEALTHCHECK_PORT:-8081}/health || exit 1

WORKDIR /
EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/coredns"]
