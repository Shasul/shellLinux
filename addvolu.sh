#!/bin/bash
error(){
	echo -e "\nRun \`./addvolu.sh -h' for more information." >&2
	exit 1
}

usage(){
	echo -e "\naddvolu.sh: Add space to disk, VG, LV, and FS\n        ./addvolu.sh [fsname] [size to add (GO)]\n        examples: ./addvolu.sh /test 1     ./addvolu.sh /test 1.5"
}

 
case $1 in
	*/) error;exit 1;;
	-h) usage;exit 1;;
	/*) ;;
	*) error;exit 1
esac

case $2 in
	0) error;exit 1;;
	[0-9]*) ;;
	*) error;exit 1
esac

df -TPh |grep " ${1}$"
if [ $? != 0 ]
    then
        echo "Error : Filesystem does not exist"
        error
fi
if [ $(grep -c $1 /etc/fstab) -gt 1 ]
        then
                echo "Error : Vérifiez le contenu du fichier /etc/fstab"
                error
fi
FT=$(df -TPh |awk '$NF == "'$1'" {print $3}')
LV=$(awk '$2 == "'$1'" {print $1}' /etc/fstab |awk -F/ '{print $4}' |awk -F- '{print $2}')
lvs |grep ${LV} >/dev/null 2>&1
if [ $? == 0 ]
        then
                echo "lv : "${LV}
        else
		lvs
                echo "Choisir un lv (si votre lv n'est pas présent, vous êtes en présence d'une partition pricipale non extensible !! Dans ce cas-là, envoyer un change create lun au SAN !!)"
		read LV
fi
VG=$(lvs |awk '$1 == "'${LV}'" {print $2}')
echo "vg : "${VG}
DISQ=$(pvs |awk '$2 == "'${VG}'" {print $1}' |awk -F/ '{print $3}')
echo "disque : "${DISQ}
VGFREE=$(vgs |awk '$1 == "'${VG}'" {print $NF}')
VGFREE=${VGFREE%?}
if [ $(echo "${VGFREE} < ${2}"|bc) -eq 1 ]
	then
		echo 1 > /sys/block/${DISQ}/device/rescan
                        if [ $? == 0 ]
                                then
                                        echo "Volumétrie disponible totalement découverte"
                                else
                                        echo "Error : discover failed"
                                        error
                        fi
                        fdisk -l /dev/${DISQ}
                        pvresize /dev/${DISQ}
                        if [ $? == 0 ]
                                then 
					echo "pvresize successfull"
                                else
                                        echo "Error : pvresize failed"
                                	error
                        fi
		PVFREE=$(pvs |awk '$1 == "/dev/'${DISQ}'" {print $6}')
		PVFREE=${PVFREE%?}
		if [ $(echo "${PVFREE} < ${2}"|bc) -eq 1 ]
			then
				echo "Voici le chemin SCSI:"
				ls -la /dev/disk/by-path/pci-0000\:00\:*| awk '$11 == "../../'${DISQ}'" '| awk -F- '{print $5}'
				echo "Emettre un change manage filesystems au SAN pour extension du disque"
				error
		fi
fi
VGLV=$(awk '$2 == "'$1'" {print $1}' /etc/fstab |awk -F/ '{print $4}')
if [ $(grep -c ${VGLV} /etc/fstab) -gt 1 ]
	then 
		echo "Error : Vérifiez le contenu du fichier /etc/fstab"
		error
fi
lvextend -L +${2}G /dev/mapper/${VGLV}
if [ $? == 0 ]
        then
                echo "Vg et lv étendus"
        else
                echo "Error : extend vg and lv failed"
                error
fi
resize2fs /dev/mapper/${VGLV}
if [ $? == 0 ]
        then
		LT=$(df -TPh |awk '$NF == "'$1'" {print $3}')
                echo "Fs étendu de ${FT} à ${LT} "
        else    
		ext2online /dev/mapper/${VGLV}
			if [ $? == 0 ]
				then
					LT=$(df -TPh |awk '$NF == "'$1'" {print $3}')
					echo ${FT} ${LT}
					echo "Fs étendu de ${FT} à ${LT}"           
				else
					echo "Error : extend fs failed"					
					error
			fi
fi
