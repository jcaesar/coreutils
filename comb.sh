
feat=(
    #arch
    #base32
    base64
    basename
    #35#cksum
    #comm
    #cp
    #csplit
    cut
    #date
    #dircolors
    #dirname
    #du
    echo
    env
    #35#expand
    #35#factor
    #35#false
    #35#fmt
    #35#fold
    #35#hashsum
    #35#head
    #35#join
    #35#link
    #35#ln
    #35#ls
    #35#mkdir
    #35#mktemp
    #35#mv
    #35#nl
    #35#nproc
    #35#numfmt
    #35#od
    #35#paste
    #35#printenv
    #35#printf
    #35#ptx
    #35#pwd
    #35#readlink
    #35#realpath
    #35#relpath
    #35#rm
    #35#rmdir
    #35#seq
    #35#shuf
    #35#sleep
    #35#sort
    #35#split
    #35#sum
    #35#sync
    #35#tac
    #35#tail
    #35#tee
    #35#test
    #35#touch
    #35#tr
    #35#true
    #35#truncate
    #35#tsort
    #35#unexpand
    #35#uniq
    #35#whoami
    #35## Manually disabled
    #35##df # Uses filesystem extensions
    #35##expr # WTF? Causes linker failure... Possibly some kind of multi-version problem?
    #35##pr
    #35##shred # Works, but I wouldn't trust it...
    #35##hostname # requires disabling the "set" flag on the hostname dependency
    #35## Problems with zero-copy and nix
    #35##cat
    #35##more
    #35##wc
    #35##yes
    #35## Nix
    #35##chgrp
    #35##chmod
    #35##chown
    #35##chroot
    #35##groups
    #35#hostid
    #35##id
    #35#install
    #35##kill
    #35#logname
    #35#mkfifo
    #35#mknod
    #35##nice
    #35##nohup
    #35##pathchk
    #35##stat
    #35##timeout
    #35#tty
    #35##uname
    #35#unlink
    #35## UTMP
    #35##pinky
    #35##uptime
    #35##users
    #35##who
)

echo "Feat: ${#feat[@]}"

"$(dirname "$0")"/waskid.sh "${feat[*]}"
