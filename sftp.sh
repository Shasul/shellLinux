#!/bin/bash
error(){
    echo -e "\nRun \`./newvolu.sh -h' for more information." >&2
    exit 1
}
usage(){
    echo -e "\nsftp.sh: Create an SFTP access for a user and a jail for him\n   ./sftp.sh [user] [jail directory]\n     example: ./sftp.sh gaga /tmp/marine"
    exit 1
}


case $1 in 
        -h) usage;;
        *)  ;;
esac

case $2 in
        -h) usage;;
        */) error;;
        /*) ;;
        *)  error;;
esac

grep $1 /etc/passwd >/dev/null 2>&1
if [ $? != 0 ]
    then
        echo "Utilisateur inexistant"
        error
fi
if [ "$(find / -wholename $2)" != $2 ]
    then
        echo "Répertoire inconnu"
        error
fi
if [ "$(ls -la $2|awk '$NF == "." {print $1}')" != "drwxr-xr-x." ]
    then
        echo "Mauvaises permissions sur le répertoire jail, veuillez les passer en 755"
        exit
fi
GR=$(grep "$1" /etc/group |cut -d: -f1)
if [ -z ${GR}]
    then
        echo "Utilisateur sans groupe"
        exit
fi

if [ "$(ls -la $2 |awk '$NF == "." {print $3}')" == "root" ]
    then
        grep "/usr/libexec/openssh/sftp-server" /etc/ssh/sshd_config >/dev/null 2>&1
        if [ $? != 0 ]
            then
                grep "internal-sftp" /etc/ssh/sshd_config >/dev/null 2>&1
                if [ $? != 0 ] 
                    then
                        echo "Warning : Vérifier le contenu de /etc/ssh/sshd_config"
                        exit
                    else
                        echo "Une configuration de compte sftp est déjà paramétrée"
                        cat << EOF >> /etc/ssh/sshd_config
Match User $1
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no

Match Group ${GR}
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no
EOF
                        service sshd restart
                fi
            else
                sed -i "s/\/usr\/libexec\/openssh\/sftp-server/internal-sftp/g" /etc/ssh/sshd_config
                cat << EOF >> /etc/ssh/sshd_config
Match User $1
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no

Match Group ${GR}
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no
EOF
                service sshd restart
        fi
    else
        mount -o bind $2 $2
        cat << EOF >> /etc/ssh/sshd_config
Match User $1
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no

Match Group ${GR}
        ChrootDirectory $2
        AllowTCPforwarding no
        X11Forwarding no
EOF
fi
