#!/bin/bash
source /root/fonctions.fonc
while true 
do
	read -p "Faites votre choix : [1,2,3]" CHOICE
	case ${CHOICE} in
		1) save ;;
		2) suppr ;;
		3) list ;;
		*) echo "Va te faire";;
	esac
done
