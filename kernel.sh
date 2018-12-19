#!/bin/bash
if [ "$(uname -r|awk -F- '{print $1}')" == "3.10.0" ]
    then
        VERS7=$(uname -r|awk -F- '{print $2}'|awk -F. '{gsub(/\.el7\.x86_64/,"");print}')
        MAJ7=$(awk '{print $(NF-1)}' /etc/redhat-release)
        if [ "${MAJ7}" == "7.3" ]
            then
                if [ "$(echo ${VERS7}|awk -F. '{print $1}')" -ge 514 ]
                    then echo ${HOSTNAME} "- Version kernel RHEL7.3 ok"
                    else echo ${HOSTNAME} "- Version kernel RHEL7.3 nok"
                fi
        fi
        if [ "${MAJ7}" == "7.2" ]
            then
                if [ "$(echo ${VERS7}|awk -F. '{print $1}')" -ge 327 ]
                    then echo ${HOSTNAME} "- Version kernel RHEL7.2 ok"
                    else echo ${HOSTNAME} "- Version kernel RHEL7.2 nok"
                fi
        fi
    exit 0
fi

if [ "$(uname -r|awk -F- '{print $1}')" == "2.6.32" ]
    then
        VERS6=$(uname -r|awk -F- '{print $2}'|awk -F. '{gsub(/\.el6\.x86_64/,"");print}')
            if [ "$(echo ${VERS6}|awk -F. '{print $1}')" -ge 696 ]
                then echo ${HOSTNAME} "- Version kernel RHEL6.9 ok"
                else echo ${HOSTNAME} "- Version kernel RHEL6.9 nok"
            fi
    exit 0
fi

echo ${HOSTNAME} "- Version unknown"
