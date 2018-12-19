#!/bin/bash
#if [ $1 -lt 0 ]
[[ $1 = +([0-9]) ]] && echo "ok"
