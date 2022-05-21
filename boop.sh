#!/usr/bin/env bash

set -e

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
    expr # WTF? Causes linker failure... Possibly some kind of multi-version problem?
    pr
    #shred # Works, but I wouldn't trust it...
    hostname # requires disabling the "set" flag on the hostname dependency
    # Problems with zero-copy and nix
    cat
    more
    wc
    yes
    # Nix
    chgrp
    chmod
    chown
    chroot
    groups
    hostid
    id
    install
    kill
    logname
    mkfifo
    mknod
    nice
    nohup
    pathchk
    stat
    timeout
    tty
    uname
    unlink
    # UTMP
    pinky
    uptime
    users
    who
)

mkdir -p boop
for f in ${feat[@]}; do
	test -e boop/$f && continue || true
	"$(dirname "$0")"/waskid.sh "$f" || continue
	cp "$(dirname "$0")"/wasm-target/wasm32-unknown-emscripten/release/coreutils.wasm boop/$f
	chmod a+x boop/$f
done
