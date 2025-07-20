FROM golang:1.24 AS builder

COPY coredns /src
WORKDIR /src
RUN export GOFLAGS="-buildvcs=false"; make gen && make

FROM debian:stable-slim AS runner

COPY --from=builder /src/coredns /coredns

RUN export DEBCONF_NONINTERACTIVE_SEEN=true \
           DEBIAN_FRONTEND=noninteractive \
           DEBIAN_PRIORITY=critical \
           TERM=linux; \
    apt-get -qq update \
    && apt-get -yyqq upgrade \
    && apt-get -yyqq install curl ca-certificates libcap2-bin \
    && apt-get clean

HEALTHCHECK --interval=5s --timeout=5s --retries=1 \
    CMD curl -f localhost:8081/health || exit 1

WORKDIR /
EXPOSE 53/tcp 53/udp
ENTRYPOINT ["/coredns"]
