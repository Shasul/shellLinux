#!/bin/bash
DAC=1
while true 
do	
    read -p  "Choisissez un répertoire : " DIR
    while read LISTDIR
    do
        if [ "${DIR}" == "${LISTDIR}" ]
	    then 
		DAC=0	
		    break
	    fi
    done < <(find / -type d 2> /dev/null)
    if [ "${DAC}" == 0 ]
	then 
            echo "Répertoire trouvé"
            break
        else
            echo "Répertoire absent, réessayez"
    fi
done
while read PIC
do
#    ANN=$(stat -c %y ${DIR} |awk '{print substr($1,1,4)}')
#    MOI=$(stat -c %y ${DIR} |awk '{print substr($1,6,2)}')
#    JOU=$(stat -c %y ${DIR} |awk '{print substr($1,9,2)}')
    ARBO=/$(stat -c %y ${DIR} |awk '{print substr($1,1,4)}')/$(stat -c %y ${DIR} |awk '{print substr($1,6,2)}')/$(stat -c %y ${DIR} |awk '{print substr($1,9,2)}')
    mkdir -p "${ARBO}" 
    cp -p ${PIC} "${ARBO}"
    if [ -n $(find ${ARBO} -name ${PIC} 2> /dev/null) ]
        then
            echo "${ARBO}${PIC}"
    fi
done < <(find "${DIR}" -regextype posix-egrep -regex ".*\.(jpg|avi|raw)$")
