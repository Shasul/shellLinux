#!/bin/bash
UNAME=$(uname)
HOSTNAME=$(hostname)
if [ ${UNAME} != "Linux" ]
    then exit
fi
for i in $(lvs |awk  ' $2 == "rootvg" {print $1}')
do echo "${HOSTNAME};$i"
done
