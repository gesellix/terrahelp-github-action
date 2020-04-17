FROM alpine:3

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh go"]
RUN ["/bin/sh", "-c", "go get github.com/opencredo/terrahelp"]

ENTRYPOINT ["/root/go/bin/terrahelp"]
