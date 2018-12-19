#!/bin/bash
for S_FILE in $(find /restit)
do
    PERM_OWN=($(stat -c "%a %U:%G" ${S_FILE}))
    D_FILE="${S_FILE#\/restit}"
    if [ -e "${D_FILE}" ]
    then
        chmod ${PERM_OWN[0]} ${D_FILE}
        chown ${PERM_OWN[1]} ${D_FILE}
		echo ${PERM_OWN} ${D_FILE}
    fi
done