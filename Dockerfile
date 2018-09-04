FROM crystallang/crystal as builder
RUN mkdir /app
WORKDIR /app
ADD shard.lock /app/shards.lock
ADD shard.yml /app/shards.yml
ADD . /app
RUN shards build --release --static --no-debug
FROM ubuntu:latest
RUN mkdir /app
WORKDIR /app
EXPOSE 3000
COPY --from=builder /app/bin/looking-glass /app/app
CMD ["/app/app"]