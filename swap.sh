#!/bin/bash
SUM=0
OVERALL=0
for DIR in $(find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+")
do
    PID=$(echo $DIR | cut -d / -f 3)
    PROGNAME=$(ps -p $PID -o comm --no-headers)
    CPU=$(ps --pid=${PID} -O %cpu |awk '$1=="'${PID}'" {print $2}')
    MEM=$(ps aux |grep ${PID}|grep -v grep| awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("%s",sum / 1024)}')
    for SWAP in $(grep Swap $DIR/smaps 2>/dev/null | awk '{ print $2 }')
    do
        let SUM=$SUM+$SWAP
    done
    if (( $SUM > 0 ))
        then echo "PID:$PID CPU ${CPU}% ; mem ${MEM} MB ; swap $SUM KB ($PROGNAME)"
        else echo "PID:$PID CPU ${CPU}% ; mem ${MEM} MB ($PROGNAME)"
    fi
    let OVERALLSWAP=$OVERALLSWAP+$SUM
    SUM=0
done
echo "Overall memory used: $(free -m|awk '$1=="Mem:" {print $3}') MB , free: $(free -m|awk '$1=="Mem:" {print $4}') MB , shared: $(free -m|awk '$1=="Mem:" {print $5}') MB , cached: $(free -m|awk '$1=="Mem:" {print $6}') MB available: $(free -m|awk '$1=="Mem:" {print $7}') MB"
echo "Overall swap used: $OVERALLSWAP KB" 
