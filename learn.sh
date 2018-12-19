#!/bin/bash
#for ext in jpg avi
#do
commande pour recup date et nom de fic ( sans muylti espace ) :
ls -l --time-style="+%Y/%m/%d" Images/ | tr -s " " | cut -d " " -f6-
commande pour recup date et nom de fic ( gere les multi espace ):
ls -l --time-style="+#@%Y/%m/%d" Images/*.jpg | awk -F"#@" '/^-/ { print $2 }' 
commande pour recup date et nom de fic ( gere muylti espace + récursivité ) : 
find Images/ -type f -name "*.jpg" -printf "%TY/%Tm/%Td %h/%f\n"

commande avec multi espace + recursivité + multi extention : 
ext="jpg|avi"
find Images/ -type f -regextype "posix-egrep" -regex ".*\.($ext)$" -printf "%TY/%Tm/%Td %h/%f\n"





source ~/.ficext
ext="jpg|avi"
	find Images/ -type f -regextype "posix-egrep" -regex ".*\.($ext)$" -printf "%TY/%Tm/%Td %h/%f\n" |\
	while read date fic
	do
		echo "mkdir -p /tmp/$date"
		echo "cp $fic /tmp/$date/${fic##*/}"
	done
#done
