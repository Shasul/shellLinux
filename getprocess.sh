#!/bin/bash
CRIT=$(echo $1)
if [ $# != 1 ]
	then
		if [ $# == 0 ]
			then 
				read -p "Veuillez ressaisir un nom :" CRIT
				if [ -z "${CRIT}" ]
					then CRIT=$(whoami)
				fi
		fi
		COUNT=$(echo ${CRIT}|wc -w)
		if [ $# -gt 1 ] || [ "${COUNT}" -gt 1 ]
			then 
				echo -e "Mauvais arguments\nget-process.sh [nom_process]"
				exit 3
		fi	
fi
PROC=$(ps -edf |awk 'NR==1 || $1=="'${CRIT}'" {print}')
DATE=$(date "+%H:%M:%S")
echo -e "------------------------------------------\nListes des processus contenant : $1\n------------------------------------------\n${PROC}\n------------------------------------------\n${DATE} - FIN de traitement"
