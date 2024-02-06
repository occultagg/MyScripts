
#!/bin/bash 
 
 
# 
startdate="$1"
date1=$(date -d "$1" "+%s") 
date2=$(date -d "$2" "+%s") 
date_count=$(echo "$date2 - $date1"|bc) 
day_m=$(echo "$date_count"/86400|bc) 
for ((sdate=0;sdate<"$day_m";sdate++)) 
do 
        echo $(date -d "$startdate $sdate days" "+%F") 
##############################################################################
#使用示例:
#./printRangdate.sh 20200125 20200825
