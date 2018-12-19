#!/bin/bash
HOSTNAME=$(hostname)
if [ "$(rpm -qa |grep "samba*" >/dev/null 2>&1;echo $?)" != 0 ]
    then 
        INSTALLED="installed nok"
        STARTED="started nok"
        CONF="no conf"
    else INSTALLED="installed ok"
        BUILDDATE=$(rpm -qi samba |awk '$1 == "Build" && $2 == "Date" {print $6" "$5}')
        MODIFYDATE=$(ls -l /etc/samba/smb.conf |awk '{print $6" "$7}')
        if [ "${BUILDDATE}" != "${MODIFYDATE}" ]
            then CONF="conf"
            else CONF="noconf"
        fi
        if [ "$(service smb status >/dev/null 2>&1;echo $?)" != 0 ]
            then STARTED="started nok"
            else STARTED="started ok"
    fi
fi
echo "${HOSTNAME};${INSTALLED};${STARTED};${CONF}"

