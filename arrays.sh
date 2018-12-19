#!/bin/bash
UNITS=( "auth,user.*" "kern.*" "daemon.*" "syslog.*" "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" )
VALUES=( "/var/log/messages" "/var/log/kern.log" "/var/log/daemon.log" "/var/log/syslog" "/var/log/unused.log" )
for ((i = 0; i < "${#UNITS[@]}"; i++))
do FICLOG=$(awk ' $1 == "'${UNITS[$i]}'" {print $2} ' /etc/rsyslog.conf)
if [ "${FICLOG}" != "${VALUES[$i]}" ]
then
        echo "NOK $i"
        exit
fi
done