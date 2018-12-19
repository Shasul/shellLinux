#!/bin/bash
CRIT=$(echo $1)
[[ $# != 1 ]] && {
	[[ $# == 0 ]] && {
		read -p "Veuillez ressaisir un nom :" CRIT
		[[ -z "${CRIT}" ]] && {
			CRIT=$(whoami)
		}
	}
	COUNT=$(echo ${CRIT}|wc -w)
	[[ $# -gt 1 || "${COUNT}" -gt 1 ]] && {
		echo -e "Mauvais arguments\nget-process.sh [nom_process]"
		exit 3
	}
}
PROC=$(ps -edf |awk 'NR==1 || $1=="'${CRIT}'" {print}')
DATE=$(date "+%H:%M:%S")
echo -e "------------------------------------------\nListes des processus contenant : $1\n------------------------------------------\n${PROC}\n------------------------------------------\n${DATE} - FIN de traitement"	
