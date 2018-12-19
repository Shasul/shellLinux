#!/bin/bash
LISTE=$(find /tmp -name listusersmaj.txt)
if [ "${LISTE}" != "/tmp/listusersmaj.txt" ]
        then
	while true
	do
	        read -p "Base de nom des comptes a créer :" BASE
	        if [[ "${BASE}" = +([[:lower:]]) ]]
	                then break
	        fi
	done
	while true
	do
        	read -p "Nombre d'utilisateurs a créer :" NBR
        	if [[ "${NBR}" = +([[:digit:]]) ]]
                	then break
        	fi
	done
	read -p "Numero du premier utilisateur (défaut: 1) :" NUM
	if [ -z ${NUM} ]
        	then NUM=1
	fi
	COUNT=0
	while (( "${COUNT}"<"${NBR}" ))
	do
        	for USER in $(awk -F: '{print $1}' /etc/passwd)
        	do
                	if [ "${USER}" = "${BASE}${NUM}" ]
                        	then exit 1
                	fi
        	done
        	echo "Creation du compte : ${BASE}${NUM}"
		useradd ${BASE}${NUM}
		if [ $? != 0 ]
        		then echo "Création utilisateur en erreur"
			else echo "Création utilisateur ok"
        	fi	
        	((COUNT++))
        	((NUM++))
	done
	exit 0
fi
while read NOM HOMDIR USSHEL
do
	if [ "$(echo ${HOMDIR}|awk -F/ '{print $NF}')" == "${NOM}" ]
		then
			useradd -b $(echo ${HOMDIR}|awk -F/ '{gsub($NF,"");print}') -m -s ${USSHEL} ${NOM}
	fi
	SHEXIST=$(dpkg -l|awk '$2=="'${USSHEL}'" {print}')
	if [ -z ${SHEXIST} ]
		then
			USSHEL="/bin/bash"
	fi
	echo "Creation du compte : ${NOM} ${HOMDIR} ${USSHEL}"
	useradd -b ${HOMDIR} -m -s ${USSHEL} ${NOM}
	if [ $? != 0 ]
	then echo "Création utilisateur en erreur"
	else echo "Création utilisateur ok"
	fi	
done < /tmp/listusersmaj.txt
