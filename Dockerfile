FROM alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add -U ruby ruby-dev ruby-bundler imagemagick6 imagemagick6-dev alpine-sdk

RUN mkdir /riina

WORKDIR /riina

ADD riina.rb /riina/riina.rb
ADD Gemfile /riina/Gemfile

RUN bundle install --path vendor/bundler

ENTRYPOINT ["bundle", "exec", "ruby", "riina.rb"]
