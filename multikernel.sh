#!/bin/bash
IFS='
'
KERNEL=$(rpm -qa kernel)
if [ "$(echo "${KERNEL}"|wc -l)" -gt 2 ]
    then
        echo ${HOSTNAME}
        echo -e "\n"
        echo "Nombre de kernels installés excessif:"
        echo "${KERNEL}"
        echo -e "\n"
        echo "Kernel actif:"
        echo $(uname -r)
fi
