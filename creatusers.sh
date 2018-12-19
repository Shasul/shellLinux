#!/bin/bash
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
	((COUNT++))
	((NUM++))
done
