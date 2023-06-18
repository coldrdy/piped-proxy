FROM rust:slim as BUILD

WORKDIR /app/

COPY . .

RUN cargo build --release && \
    mv target/release/piped-proxy .

FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY --from=BUILD /app/piped-proxy .

EXPOSE 8080

CMD ["/app/piped-proxy"]
