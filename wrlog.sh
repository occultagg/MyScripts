#!/bin/bash
#

wrlog() {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`]-$1-$2" | tee -a ./logs/script.log
}

wrlog "INFO" "LOG-MESSAGE"
