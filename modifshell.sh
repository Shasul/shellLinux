#!/bin/sh
cp -p /etc/passwd /etc/passwd.backup
awk -F: '{if ($1 == "sapadm" && $NF != "/bin/false") print $1":"$2":"$3":"$4":"$5":"$6":/bin/false";else print;}' /etc/passwd > /etc/passwd.tmp
chmod 644 /etc/passwd.tmp
if [ "$(awk -F: '/^sapadm:/ {print $NF}' /etc/passwd.tmp)" == "/bin/false" ];
	then
		echo "Verif ok"
		mv -f /etc/passwd.tmp /etc/passwd
	else
		echo "verif nok, valeur non remplacée dans /etc/passwd"
		rm -rf /etc/passwd.tmp
fi
