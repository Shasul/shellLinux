	LOG=( "/var/log/aide" "/var/log/journaux/full-log" "/var/log/cron" "/var/log/maillog" "/var/log/messages" "/var/log/secure" "/var/log/spooler" )
	for (( i=0;i<"${#LOG[@]}";i++ ))
	do RULE=$(grep -e "^${LOG[$i]}$" /etc/logrotate.d/syslog)
	if [ -z ${RULE} ]
	then
        	SEC_MESSAGE="Line missing ${LOG[$i]} in /etc/logrotate.d/syslog "
        	return  $_STATUS_RESERVE_BLOQUANTE
	fi
	done
	ARRAY=( "{" "daily" "rotate 366" "create 0600 root root" "compress" "sharedscripts" "postrotate" "/bin/kill -HUP \`cat /var/run/syslogd.pid 2> /dev/null\` 2> /dev/null || true" "/bin/kill -HUP \`cat /var/run/rsyslogd.pid 2> /dev/null\` 2> /dev/null || true" "endscript" "}" )
	BEG=$(awk '$1 == "{" {print NR}' /etc/logrotate.d/syslog)
	END=$(awk '$1 == "}" {print NR}' /etc/logrotate.d/syslog)
	INC=0
	for ((i = "${BEG}"; i <= "${END}"; i++))
	do
	UNIT=$(awk ' NR == "'$i'" {gsub(/^[ \t]*/,"",$0);print}' /etc/logrotate.d/syslog)
	if [ "${UNIT}" != "${ARRAY[${INC}]}" ]
	then
        	SEC_MESSAGE="Line missing ${ARRAY[${INC}]} in /etc/logrotate.d/syslog on line $i "
		return  $_STATUS_RESERVE_BLOQUANTE
	fi
	INC=$(echo $((${INC}+1)))
	done
	SEC_MESSAGE="Conforme "
	return $_STATUS_CONFORME