#/bin/bash
MOUNT_OPT=$(awk '$2=="/tmp" {print $4}' /etc/fstab)
MOUNT_STA=$(mount |awk '$3=="/tmp" {print $6}')
if [[ "${MOUNT_OPT}" =~ ^.*noexec.*$ ]]
    then OPT=yes
    else OPT=null
fi
if [[ "${MOUNT_STA}" =~ ^.*noexec.*$ ]]
    then STA=yes
    else STA=null
fi
echo "$(hostname);${OPT};${STA}"
