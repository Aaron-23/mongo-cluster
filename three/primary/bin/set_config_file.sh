#!/bin/bash

source /tmp/bin/env

function set_config() {
    CFG=($(env | sed -nr "s/CFG_([0-9A-Z_a-z-]*)/\1/p"|tr A-Z a-z))

    for CFG_KEY in "${CFG[@]}"; do
        KEY=`echo $CFG_KEY | cut -d = -f 1`
        VAR=`echo $CFG_KEY | cut -d = -f 2`
        if [ "$VAR" == "" ]; then
            echo "Empty volue for option \"$KEY\"."
            continue
        fi
        grep -q "$KEY" $CONFIG_FILE
        if (($? > 0)); then
            echo "${KEY}${DELIMITER}${VAR}" >> $CONFIG_FILE
            echo "Config add option for \"$KEY\"."
        else
            sed -i -r "s~($KEY)${DELIMITER}.*~\1${DELIMITER}$VAR~g" $CONFIG_FILE  >/dev/null 2>&1
            echo "Option found for \"$KEY\"."
        fi
    done
}

set_config
