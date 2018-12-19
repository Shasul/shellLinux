#!/bin/bash
#set -x

IFS='
'
DIR=/root/FILM
OBST=( "FRENCH" "PROPER" "FINAL" "UNRATED" "TRUEFRENCH" "Truefrench" "FiNAL" "french" "FASTSUB" "VOSTFR" )
EXTE=( "avi" "mkv" "mp4" )
while true
do
    read -p 'Entrer le répertoire cible:' DIR
    if [ -n "$(find / -wholename ${DIR})" ]
        then break
    fi
done

for DOSS in $(find ${DIR} -type d|awk 'NR>1 {print}')
do
    DOSN=$(echo ${DOSS}|awk '{gsub(/ /,"",$0);print}')
    DOSN=$(echo ${DOSN}|awk '{gsub(/\./,"",$0);print}')
    mv ${DOSS} ${DOSN}
    for ((k = 0 ; k < "${#EXTE[@]}" ; k++))
    do
        FIC=$(find ${DOSN} -type f|awk -F. '$NF=="'${EXTE[$k]}'" {print}')
        echo ${FIC}
        if [ -n "${FIC}" ]
            then
                if [ "$(echo ${FIC}|wc -l)" > 1 ]
                    then
                        for LIFIC in $(echo ${FIC})
                        do
                            mv ${LIFIC} ${DIR}
                        done
                    else
                        mv ${FIC} ${DIR}
                        break
                fi
        fi
    done
    rmdir ${DOSN} >/dev/null 2>&1
done
for FILM in $(find ${DIR} -type f)
do
    NEW=$(echo ${FILM}|awk '{gsub(" ",".",$0);print}')
    NEW=$(echo ${NEW}|awk '{gsub("'${DIR}'/","",$0);print}')
    NEW=$(echo ${NEW}|awk '{gsub(/^\[.*\]/,"",$0);print}')
    NEW=$(echo ${NEW}|awk '{gsub(/^\./,"",$0);print}')
    NEW=$(echo ${NEW}|awk '{gsub(/\.720p|\.1080p/,"",$0);print}')    
    for ((i = 0 ; i < "${#OBST[@]}" ; i++))
    do
        if [[ "${NEW}" =~ ^.*${OBST[$i]}.*$ ]]
        then
             for ((j = 0 ; j < "${#EXTE[@]}" ; j++))
             do
                 if [ "$(echo ${NEW}|awk -F. '{print $NF}')" = "${EXTE[$j]}" ]
                     then
                         NEW=$(echo ${NEW}|awk -F. '{gsub(/\.'${OBST[$i]}'.*$/,".'${EXTE[$j]}'",$0);print}')
                         break
                fi
                if [ "$j" = "$(echo ${#EXTE[@]}-1 |bc -l)" ]
                    then
                        NEW=$(echo ${NEW}|awk -F. '{gsub(/\.'${OBST[$i]}'.*/,"",$0);print}')
                        break
                fi
            done
        fi
    done
    echo ${NEW}
    mv ${FILM} ${DIR}/${NEW} >/dev/null 2>&1
done
ls -l ${DIR}
echo "Les dossiers suivants sont susceptibles de contenir des données. Ils n'ont pas été supprimés."
echo $(find ${DIR}/* -type d)

