#!/bin/bash
HOST=$(hostname)
UP=$(uptime |awk '{gsub (",","",$4)};{print $3,$4}')
echo ${HOST}   
