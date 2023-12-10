#!/bin/bash

export CFLAGS="-g -O2 -W -Wall"
export CC=afl-clang-lto
export CXX=afl-clang-lto++
export AFL_CC_COMPILER=LTO

make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-normal

make clean
AFL_LLVM_LAF_ALL=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-laf-intel

make clean
AFL_LLVM_CMPLOG=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-cmplog

make clean
AFL_USE_ASAN=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-asan

make clean
AFL_USE_MSAN=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-msan

make clean
AFL_USE_UBSAN=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-ubsan

make clean
AFL_USE_CFISAN=1 make
mv src/dnsmasq /fuzz/dnsmasq-fuzz-cfisan