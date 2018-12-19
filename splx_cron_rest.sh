#!/bin/bash
INSTALL=$(find /etc/init.d/* -name splx)
if [ -z "${INSTALL}" ]
then
    echo "splx not installed"
    exit 1
fi
CRONROOT=$(find /var/spool/cron -name root)
if [ -z "${CRONROOT}" ]
then
    echo "Cron of root missing in /var/spool/cron/root"
    exit 2
fi
LIN=$(crontab -l |grep "^1 0 1 \* \* /etc/init.d/splx restart$"|wc -l)
if [ "${LIN}" > 1 ]
    then
        sed -i 's/^1 0 1 \* \* \/etc\/init.d\/splx restart$//g' /var/spool/cron/root
        echo "1 0 1 * * /etc/init.d/splx restart" >> /var/spool/cron/root
fi