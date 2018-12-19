#!/bin/bash
for A in $(awk -F: '$1~"^adm-unix-.*" {print}' /tmp/SHADO)
do
    AA=$(echo ${A} |awk -F: '{print $1}')
    AB=$(echo ${A} |awk -F: '{print $2}')
#    awk -F: ' $1=="'${AA}'" {gsub(/\!\!/,"'${AB}'");print} ' /tmp/SHADO1
    sed -i -e 's@'${AA}':\!\!@'${AA}':'${AB}'@g' /tmp/SHADO1  
done
cat /tmp/SHADO1
