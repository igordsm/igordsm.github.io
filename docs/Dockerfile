FROM alpine:edge
RUN apk add --no-cache ruby ruby-dev  gcc make build-base linux-headers musl-dev
RUN gem install bundler jekyll 
RUN mkdir /site
WORKDIR /site
EXPOSE 4000
