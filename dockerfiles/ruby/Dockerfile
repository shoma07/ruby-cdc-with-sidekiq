FROM alpine:3.14 AS jemalloc-builder

ENV JEMALLOC_VERSION="5.2.1"

WORKDIR /tmp/jemalloc

RUN apk add --no-cache build-base && \
      wget -O - https://github.com/jemalloc/jemalloc/releases/download/$JEMALLOC_VERSION/jemalloc-$JEMALLOC_VERSION.tar.bz2 | \
      tar -xj --strip-components=1 && \
      ./configure && \
      make && \
      make install

FROM ruby:3.0.2-alpine3.14

COPY --from=jemalloc-builder /usr/local/lib/libjemalloc.so.2 /usr/local/lib/

ENV LANG="C.UTF-8" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

WORKDIR /usr/src/app

RUN apk add --no-cache --virtual=build-dependencies build-base && \
    apk add --no-cache git mariadb-dev mariadb-client tzdata

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install -j4 && \
    apk del --purge build-dependencies

COPY . .
