#!/bin/bash
PROJS=("/eoc_ms/" "/flow/" "/eoc_telecom/" "/eoc_renew/" "/eoc_peccancy/" "/eoc_gw/" "/eoc_message/")

YESTERDAY=`date -d yesterday +%Y%m%d`
YESTERDAY_PATH=`date -d yesterday +%Y-%m-%d`
ANAL_FILE=/mydata/product/eoc/nginx/nginx/sbin/anal_file/${YESTERDAY_PATH}/
ANAL_DIR=/mydata/product/eoc/nginx/nginx/sbin/anal_file/
LOG_PATH=/mydata/product/eoc/nginx/nginx/logs/oldlog/${YESTERDAY}/
LOG_FILE=${LOG_PATH}host.access_${YESTERDAY}.log
SORT_TMP=/mydata/sortTMP

if [ ! -d ${ANAL_FILE} ]; then
	mkdir -p ${ANAL_FILE}
fi

if [ ! -d ${SORT_TMP} ]; then
	mkdir -p ${SORT_TMP}
fi

echo "项目,总计数,成功次数,失败次数,评价响应时间,响应时间超2s的url个数" > $ANAL_FILE/NGINX_61_count.temp
for PROJ in ${PROJS[@]}
do
#c:总计数 s:成功次数 q:响应时间大于2s的url数
	echo -n "$PROJ," >> $ANAL_FILE/NGINX_61_count.temp
	awk -F "|" '{if ($4~"'$PROJ'") print $0}' $LOG_FILE | awk -F "|" 'BEGIN {c = 0;s = 0;q = 0} {if ($11 > 2) q+=1} {c+=1} {a+=$11} {if ($5 == 200) s+=1} END {print c "," s "," c-s "," a/c "," q}' >> $ANAL_FILE/NGINX_61_count.temp
	echo "请求时间超过2s的url前十" >> $ANAL_FILE/NGINX_61_count.temp
	awk -F "|" '{if ($4~"'$PROJ'") {if ($11 > 2) print $4}}' $LOG_FILE | sort -T ${SORT_TMP} | uniq -c | sort -T ${SORT_TMP} -nrk 1 | head -n 10 >> $ANAL_FILE/NGINX_61_count.temp
done

#
/usr/bin/iconv -f UTF8 -t GBK $ANAL_FILE/NGINX_61_count.temp > $ANAL_FILE/NGINX_61_count.csv
#

cd ${ANAL_DIR}
find ./  -mtime  +10 -exec rm -rf {} \;
find ./ -depth -empty -type d -exec rmdir -v {} \;





