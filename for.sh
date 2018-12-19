#!/bin/bash
for LISTE in $(find . -regex ".*\.sh")
do
	echo ${LISTE}
	cp -p ${LISTE} ${LISTE}.save
done
