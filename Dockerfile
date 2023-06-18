FROM rust:slim as BUILD

WORKDIR /app/

COPY . .

RUN --mount=type=cache,id=cargo-registry,target=/usr/local/cargo/registry \
    --mount=type=cache,id=app-target,target=/app/target/ \
    cargo build --release && \
    mv target/release/piped-proxy .

FROM debian:stable-slim

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY --from=BUILD /app/piped-proxy .

EXPOSE 8080

CMD ["/app/piped-proxy"]
