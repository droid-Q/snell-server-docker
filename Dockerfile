FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM frolvlad/alpine-glibc:latest AS build

COPY --from=xx / /
COPY get_url.sh /get_url.sh
ARG TARGETPLATFORM
ARG VERSION

RUN ./get_url.sh ${VERSION} $(xx-info arch)
RUN xx-info env && wget -q -O snell-server.zip $(./get_url.sh ${VERSION} $(xx-info arch)) && \
    unzip snell-server.zip && rm snell-server.zip && \
    xx-verify /snell-server

FROM frolvlad/alpine-glibc:latest

ENV TZ=UTC

COPY --from=build /snell-server /usr/bin/snell-server
COPY start.sh /start.sh
RUN apk add --update --no-cache libstdc++

ENTRYPOINT /start.sh
