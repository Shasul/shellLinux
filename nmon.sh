#!/bin/bash
INST=$(lslpp -w $(which nmon)| grep "bos.perf.tools")
if [ -z "${INST}" ]
    then 
        echo ${HOSTNAME}
fi
