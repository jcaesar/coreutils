#!/usr/bin/env bash

set -e

RWD="$(dirname "$0")"

echo '
FROM debian:bullseye
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -yq \
        build-essential \
        cmake \
        curl \
        file \
        git \
        python3 \
        sudo \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd rust --user-group --create-home --shell /bin/bash --groups sudo && \
    echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" >/etc/sudoers.d/nopasswd
USER rust
RUN cd /home/rust && git clone https://github.com/emscripten-core/emsdk.git && cd emsdk && ./emsdk install 1.39.20 && ./emsdk activate 1.39.20
ENV PATH=/home/rust/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.47 --profile default --no-modify-path && \
    rustup target add wasm32-wasi && \
    rustup target add wasm32-unknown-emscripten

WORKDIR /home/rust/src
' | docker build -t rust-wasi-builder -

feat=(
    arch
    base32
    base64
    basename
    cksum
    comm
    cp
    csplit
    cut
    date
    dircolors
    dirname
    du
    echo
    env
    expand
    factor
    false
    fmt
    fold
    hashsum
    head
    join
    link
    ln
    ls
    mkdir
    mktemp
    mv
    nl
    nproc
    numfmt
    od
    paste
    printenv
    printf
    ptx
    pwd
    readlink
    realpath
    relpath
    rm
    rmdir
    seq
    shuf
    sleep
    sort
    split
    sum
    sync
    tac
    tail
    tee
    test
    touch
    tr
    true
    truncate
    tsort
    unexpand
    uniq
    whoami
    # Manually disabled
    #df # Uses filesystem extensions
    #expr # WTF? Causes linker failure... Possibly some kind of multi-version problem?
    #pr
    #shred # Works, but I wouldn't trust it...
    #hostname # requires disabling the "set" flag on the hostname dependency
    # Problems with zero-copy and nix
    #cat
    #more
    #wc
    #yes
    # Nix
    #chgrp
    #chmod
    #chown
    #chroot
    #groups
    hostid
    #id
    install
    #kill
    logname
    mkfifo
    mknod
    #nice
    #nohup
    #pathchk
    #stat
    #timeout
    tty
    #uname
    unlink
    # UTMP
    #pinky
    #uptime
    #users
    #who
)

echo "Feat: ${#feat[@]}"

mkdir -p "$RWD"/wasm-{target,cache}

exec docker run --rm -ti \
	-v $RWD:/home/rust/src \
	-v $RWD/wasm-target:/home/rust/src/target \
	-v $RWD/wasm-cache:/home/rust/.cargo/registry \
	rust-wasi-builder bash -c '
		source ~/emsdk/emsdk_env.sh;
		sudo chown rust:rust target ~/.cargo/registry \
		&& env CARGO_NET_GIT_FETCH_WITH_CLI=true cargo -v build --release --locked --target=wasm32-unknown-emscripten --no-default-features --features "'"${feat[*]}"'"
	'
