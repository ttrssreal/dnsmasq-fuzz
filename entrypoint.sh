#!/bin/bash

if [ $(nproc) -lt 8 ]; then
    echo "nproc < 8"
    exit 1
fi

export AFL_TESTCACHE_SIZE=500

tmux new -d -s afl-laf-intel -- afl-fuzz -i in -o /fuzz/mnt/ \
    -M laf-intel \
    ./dnsmasq-fuzz-laf-intel

tmux new -d -s afl-asan -- afl-fuzz -i in -o /fuzz/mnt/ \
    -S asan \
    -L 0 \
    -p lin \
    ./dnsmasq-fuzz-asan

#not worky
# tmux new -d -s afl-ubsan -- afl-fuzz -i in -o /fuzz/mnt/$(hostname)/out \
#     -S ubsan \
#     -L 0 \
#     -p exploit \
#     ./dnsmasq-fuzz-ubsan

# cmpog
tmux new -d -s afl-cmplog -- afl-fuzz -i in -o /fuzz/mnt/ \
    -S cmplog \
    -c ./dnsmasq-fuzz-cmplog \
    ./dnsmasq-fuzz-normal
# split-window
tmux split-window -h -t afl-cmplog: afl-fuzz -i in -o /fuzz/mnt/ \
    -S cmplog-follow-trans \
    -c ./dnsmasq-fuzz-cmplog \
    -l 2AT \
    ./dnsmasq-fuzz-normal

export AFL_DISABLE_TRIM=1

tmux split-window -h -t afl-laf-intel: afl-fuzz -i in -o /fuzz/mnt/ \
    -S laf-intel-2 \
    -P explore \
    -p coe \
    ./dnsmasq-fuzz-laf-intel

tmux new -d -s afl-normal -- afl-fuzz -i in -o /fuzz/mnt/ \
    -S afl-normal \
    -Z \
    -P exploit \
    -p explore \
    ./dnsmasq-fuzz-normal

tmux split-window -h -t afl-normal: afl-fuzz -i in -o /fuzz/mnt/ \
    -S afl-normal-2 \
    -L 0 \
    ./dnsmasq-fuzz-normal

tmux split-window -v -t afl-normal: afl-fuzz -i in -o /fuzz/mnt/ \
    -S afl-normal-5 \
    -L 0 \
    ./dnsmasq-fuzz-normal

if [ $(nproc) -lt 9 ]; then
    echo "started 8 fuzzers"
    tmux a
    exit 1
fi

tmux new -d -s afl-msan -- afl-fuzz -i in -o /fuzz/mnt/ \
    -S msan \
    -L 0 \
    -p quad \
    ./dnsmasq-fuzz-msan

if [ $(nproc) -lt 10 ]; then
    echo "started 9 fuzzers"
    tmux a
    exit 1
fi

# no worky
# tmux new -d -s afl-cfisan -- afl-fuzz -i in -o /fuzz/mnt/$(hostname)/out \
#     -S cfisan \
#     -P explore \
#     -p rare \
#     ./dnsmasq-fuzz-cfisan

tmux new -d -s afl-cmplog-2 -- afl-fuzz -i in -o /fuzz/mnt/ \
    -S cmplog-2 \
    -c ./dnsmasq-fuzz-cmplog \
    ./dnsmasq-fuzz-normal

if [ $(nproc) -lt 11 ]; then
    echo "started 10 fuzzers"
    tmux a
    exit 1
fi

tmux split-window -h -t afl-normal: afl-fuzz -i in -o /fuzz/mnt/ \
    -S afl-normal-3 \
    -L 0 \
    -P exploit \
    ./dnsmasq-fuzz-normal

if [ $(nproc) -lt 12 ]; then
    echo "started 11 fuzzers"
    tmux a
    exit 1
fi

tmux split-window -h -t afl-normal: afl-fuzz -i in -o /fuzz/mnt/ \
    -S afl-normal-4 \
    -L 0 \
    -Z \
    -a binary \
    ./dnsmasq-fuzz-normal

echo "started 12 fuzzers"

tmux a