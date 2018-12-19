#!/bin/bash
KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAt+ctn2aVjYkHGu/Vs8DcjTcgeEqegzu92ya9x0ohKQRTub31rzLJNWgxFLtfph4VDpgHGNvc5lIN1V6btZleOnvBMcFG1WgrFc+oZTlJpSpc487KAEfqJhVvWyqYmTkakHQRhFuve/0/1rucXllPdaOwLv4gcLVdqhpLTZ1qFJ+DvOp1IWVjjN2xYrhBuKG0M1gLitlrnyGNmAy+9S+qwGFTIEn4SbN6dvs4z05jMxe97MiSv0+WVnjJwp/9aBcnuGr3qYn9biC8aY0CieVZ4wQcVwIzrByYs2rSGLrrTCxosCT318nSCSk62SqLQe+hr9/s8GyD4UD3ngbYQuSZMw== rsa-key-20170207"
LINE=$(wc -l fic)
for i in ${LINE}
do
    CN=$(awk 'NR="'$i'" {print $1}' /root/fic)
    IP=$(awk 'NR="'$i'" {print $2}' /root/fic)
    LOGIN=$(awk 'NR="'$i'" {print $3}' /root/fic)
    echo ${CN}
    if [ "${LOGIN}" != "root" ]
    then
        ssh -l ${LOGIN} ${IP}
        echo ${KEY} >> /home/${LOGIN}/.ssh/authorized_keys
        exit
    else
        ssh -l ${LOGIN} ${IP}
        echo ${KEY} >> /${LOGIN}/.ssh/authorized_keys
        exit
    fi
done
