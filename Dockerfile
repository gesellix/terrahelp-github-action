FROM alpine:3

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh go"]
RUN ["/bin/sh", "-c", "go get github.com/opencredo/terrahelp"]
ENV PATH=$PATH:/root/go/bin/

ENTRYPOINT ["/src/main.sh"]
COPY ["src", "/src/"]
