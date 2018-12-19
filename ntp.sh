#!/bin/bash
HOSTNAME=$(hostname)
ntpstat >/dev/null 2>&1
RESULT=$(echo $?)
if [ ${RESULT} == 0 ]
then
    NTP=$(ntpq -p |awk '$1 ~ /^*/ {split($1,a,"*"); print a[2]}')
    echo "${HOSTNAME};${NTP}"
fi
if [ ${RESULT} == 1 ]
then
    echo "${HOSTNAME};unsynchronized"
fi
if [ ${RESULT} == 2 ]
then
    echo "${HOSTNAME};stopped"
fi
