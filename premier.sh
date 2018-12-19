#!/bin/bash
if [ $# == 2 ]
	then
		DATE=$(date "+%H:%M")
		HOST=$(hostname)
		echo -e "Bonjour $1 $2 \nIl est ${DATE}, bienvenue sur ${HOST}"
	else
		echo "Arguments non valides"
		exit 1
fi
