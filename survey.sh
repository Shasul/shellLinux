#!/bin/bash
PRC=$(df -Th| awk 'NR != 1 {gsub("%$","",$6);print $6}')
LINE=1
for i in ${PRC}
do
    LINE=$(echo "${LINE}+1"|bc -l)
    if [ "$i" -gt "50" ]
        then
            echo -e "\nCapacité filesystem $(df -Th |awk ' NR == "'${LINE}'" {print $7}') critique à $i%.\n"
    fi
done
while true
do
    read -p "Veuillez saisir un service ou q pour quitter: " CHOIC
    case ${CHOIC} in
        q)
            break
            ;;
        *)
            if [ -n "$(service --status-all|awk ' $4 == "'${CHOIC}'" {print}')" ]
                then
                    case $(service --status-all|awk ' $4 == "'${CHOIC}'" {print $2}') in
                        +)
                            echo -e "\nService ${CHOIC} démarré et ok\n"
                            ;;
                        -)
                            echo -e "\nService ${CHOIC} arrêté\n"
                            ;;
                        ?)
                            echo -e "\nService ${CHOIC} en erreur\n"
                            ;;
                    esac
            fi
            ;;
        esac
done
grep -h -E "^$(date "+%b %d").*" /var/log/messages |more
