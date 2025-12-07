#!/bin/bash

if [ -z ${MEMORY} ]; then
    MEMORY="1024M"
fi

java -Xms${MEMORY} -Xmx${MEMORY} -jar papermc.jar nogui