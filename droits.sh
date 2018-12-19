#!/bin/bash
for S_FILE in $(find /restit)
do
    chmod $(stat -c "%a" ${S_FILE}) ${S_FILE#\/restit}
    chown $(stat -c "%U:%G" ${S_FILE}) ${S_FILE#\/restit}
done
