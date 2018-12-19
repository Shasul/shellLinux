#!/bin/bash
DIR=$1
case ${DIR} in
	${PWD})	
		echo "Le répertoire cible et de destination ne peuvent pas être identiques"
		;;
	${HOME})
		echo "result.log"
#		touch "${DIR}/result.log"; [[ $? == 0 ]] && {echo "result.log créé"}
		;;
	"/root")
		if [ "${USER}"=="/root" ]
			then echo "result.log"
#			then touch "${DIR}/result.log"; [[ $? == 0 ]] && {echo "result.log créé"}
			else echo "Ce chemin ne peut être utilisé que pour une connexion en ROOT !"
		fi
		;;
	"")
		echo "enculé"
		;;
	*)
		for PENIS in $(awk -F: '{print $6}' /etc/passwd)
		do
			if [ "^${PENIS}$" == "${DIR}" ]
				then
					echo "La cible ne peut être enregistrée dans un répertoire utilisateur autre que le votre"
					exit 2
			fi
		done		
		if [ "$(stat --format %U ${DIR})" == "${USER}" ]
			then echo "result.log"
#			then touch "${DIR}/result.log"; [[ $? == 0 ]] && {echo "result.log créé"}
			else echo "Vous ne disposez pas des privilèges nécessaires à la création du fichier dans le répertoire demandé"
		fi
		;;
esac
