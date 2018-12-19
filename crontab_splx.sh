#!/bin/bash
EXIST=$(find /root -name crontab.bck)
if [ "${EXIST}" == "/root/crontab.bck" ]
then
        echo "fichier crontab.bck déjà existant"
        exit
else
        touch /root/crontab.bck
        crontab -l > /root/crontab.bck
        echo "1 0 1 * * /etc/init.d/splx restart" >> /root/crontab.bck
        crontab /root/crontab.bck
        rm -rf /root/crontab.bck
        echo "crontab completed"
fi