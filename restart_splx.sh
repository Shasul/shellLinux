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
echo "1 0 1 * * /etc/init.d/splx restart" >> /var/spool/cron/root
LIN=$(crontab -l |grep "^1 0 1 \* \* /etc/init.d/splx restart$")
if [ -z "${LIN}" ]
then
    echo "Check crontab: Lines for splx restart missing in crontab"
    exit 3
else
    echo "Check crontab: New crontab installed : OK"
fi