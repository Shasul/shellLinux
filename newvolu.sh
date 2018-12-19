#!/bin/bash
error(){
    echo -e "Run \`./newvolu.sh -h' for more information." >&2
    exit 1
}

usage(){
    echo -e "\nnewvolu.sh: Create a new PV, LV, FS\n        ./newvolu.sh [disk] [VGname] [LVname] [FSname] [size (GO)]\n        examples: ./newvolu.sh sdb vgtest lvtest /test 1        ./newvolu.sh sdb vgtest lvtest /test 1.5"
}


RES=0
FAU=0
case $1 in
        -h) usage;exit 1;;
        /*) error;;
        */) error;;
        *)  ;;        
esac

case $2 in
        -h) usage;exit 1;;
        *)  ;;
esac

case $3 in
        -h) usage;exit 1;;
        *)  ;;
esac

case $4 in
        */) error;;
        -h) usage;exit 1;;
        /*) ;;
        *) error;;
esac

case $5 in
        -h) usage;exit 1;;
        0) error;exit 1;;
        [0-9]*) ;;
        *) error;exit 1
esac
if [ "$(pvs |grep "/dev/${1} ">/dev/null 2>&1;echo $?)" == 1 ]
    then RES=$(echo "$RES + 1" |bc)
    else FAU=$(echo "$FAU + 1" |bc)
        echo "/dev/${1} already exists"
fi
if [ "$(vgs |grep "^  ${2} ">/dev/null 2>&1;echo $?)" == 1 ]
    then RES=$(echo "$RES + 1" |bc)
    else FAU=$(echo "$FAU + 1" |bc)
        echo "VG ${2} already exists"
fi
if [ "$(lvs |grep "^  ${3} ">/dev/null 2>&1;echo $?)" == 1 ]
    then RES=$(echo "$RES + 1" |bc)
    else FAU=$(echo "$FAU + 1" |bc)
        echo "LV ${3} already exists"
fi
if [ "$(df -TPh |grep " ${4}$">/dev/null 2>&1;echo $?)" == 1 ]
    then RES=$(echo "$RES + 1" |bc)
    else FAU=$(echo "$FAU + 1" |bc)
        echo "FS ${4} already exists"
fi

if [ "${RES}" != 4 ]
    then
echo "Error : ${FAU} parameter(s) already in use"
    error
fi
find / -wholename ${4} -type d > /dev/null 2>&1
if [ $? == 0 ]
    then
    echo "Error : cannot create directory  ${4} : File exists"
    error
fi
for i in $(ls -l /sys/class/scsi_host/ |awk 'NR != 1 {gsub("host","",$9);print $9}')
	do
		echo "- - -" > /sys/class/scsi_host/host"$i"/scan
	done
pvcreate /dev/$1
	if [ $? == 0 ]
             then
                vgcreate $2 /dev/$1
		lvcreate -L ${5}G -n $3 $2
		mkfs.ext4 /dev/mapper/$2-$3
		if [ $? == 0 ]
		    then
		        echo "Formatage réussi"
	            else 	
		        ls -l /dev/mapper/ |awk '$NF != "control" {print $9}'
                	echo "Choisir la combinaison correspondante"
			read VGLV
			mkfs.ext4 /dev/mapper/${VGLV}
			if [ $? == 0 ]
        		    then
                	        echo "Formatage réussi"
			    else
			        echo "Formatage échoué"
                                error
			fi
		fi
		mkdir ${4}
		if [ awk '$1 != "/dev/mapper/'${VGLV}'" || $2 != "'${4}'"' /etc/fstab ] 2>/dev/null
		    then
		        echo "/dev/mapper/${VGLV} ${4}                ext4    defaults        1 2" >> /etc/fstab
			mount ${4}
			if [ $? == 0 ]
        		    then
                	        echo "FS monté"
        		    else
                	        echo "Echec de montage"
                                error
			fi
		    else
			echo "Ligne déjà présente dans /etc/fstab, la supprimer manuellement"
                        error
		 fi
	    fi
