#!/usr/bin/env bash

set -e

RWD="$(dirname "$0")"

echo '
FROM docker.io/library/debian:bullseye as bin
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -yq \
        build-essential \
        cmake \
        curl \
        file \
        git \
        python3 \
        python \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd rust --user-group --create-home --shell /bin/bash
USER rust
RUN cd /home/rust && git clone https://github.com/emscripten-core/emsdk.git && cd /home/rust/emsdk && ./emsdk install 1.38.43 && ./emsdk activate 1.38.43
ENV PATH=/home/rust/.cargo/bin:/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.35 --profile default --no-modify-path && \
    rustup target add wasm32-unknown-emscripten
WORKDIR /home/rust/src
' | docker build -t rust-wasi-builder -


mkdir -p "$RWD"/wasm-{target,cache}

set -x
exec docker run --rm -ti \
	-v $RWD:/home/rust/src \
	-v $RWD/wasm-target:/home/rust/src/target \
	-v $RWD/wasm-cache:/home/rust/.cargo/registry \
	rust-wasi-builder bash -c '
		source /home/rust/emsdk/emsdk_env.sh;
		env CARGO_NET_GIT_FETCH_WITH_CLI=true cargo -v build --release --target=wasm32-unknown-emscripten --no-default-features --features "'"$1"'"
	'
