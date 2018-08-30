#!/bin/sh

d="`dirname $0`"

gtar czf kheperacomm-src-0.1.tar.gz "$d"/README "$d"/Makefile \
"$d"/maketgz.sh "$d"/*.c "$d"/*.m
