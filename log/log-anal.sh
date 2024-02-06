#!/bin/bash

#awk -F '|'  'BEGIN {max = 0} {if ($(NF-1)+0 > max+0) max=$(NF-1)} {a+=$(NF-1)} END {print  $4"avergetime=" a/NR " number="NR " max="max}'
#输出格式：
#接口                     日访问量     平均调用时长（S）  超时次数408   错误次数  访问最大时长（S）
#/servicer/upload/error  1113400001      400              500           20          40


YESTERDAY=`date -d yesterday +%Y%m%d`
YESTERDAY_PATH=`date -d yesterday +%Y-%m-%d`
#修改路径
ANAL_FILE=/mydata/product/eoc/nginx/nginx/sbin/anal_file/${YESTERDAY_PATH}/
ANAL_DIR=/mydata/product/eoc/nginx/nginx/sbin/anal_file/
#修改路径
LOG_PATH=/mydata/product/eoc/nginx/nginx/logs/oldlog/${YESTERDAY}/
#修改
LOG_FILE=${LOG_PATH}host.access_${YESTERDAY}.log
SORT_TMP=/mydata/sortTMP

if [ ! -d ${ANAL_FILE} ]; then
	mkdir -p ${ANAL_FILE}
fi

if [ ! -d ${SORT_TMP} ]; then
	mkdir -p ${SORT_TMP}
fi

#提取除了"-"外的url

awk -F '|' '{if ($4 != "\"-\"") print $4}' ${LOG_FILE} | sort -T ${SORT_TMP} | uniq -c | sort -T ${SORT_TMP} -nrk 1 | head -n 100 > ${ANAL_FILE}urls.temp

awk '{print $2,$3,$4}' ${ANAL_FILE}urls.temp > ${ANAL_FILE}urls.list

while read line
do
	grep "${line}" ${LOG_FILE} |awk -F '|'  'BEGIN {max=0}{b=0}{c=0} {if ($(NF-1)+0 > max+0) max=$(NF-1)} {if ($5 == 408) b+=1}  {if ($5 != 200 && $5 != 408) c+=1} {a+=$(NF-1)} END {print  $4 "," NR "," a/NR "," b "," c "," max}' >> ${ANAL_FILE}result.temp
done < ${ANAL_FILE}urls.list

#提取"-"的url
awk  -F '|'  '{if ($4 == "\"-\"") print $0} ' ${LOG_FILE} | awk -F '|'  'BEGIN {max = 0}{b=0}{c=0} {if ($(NF-1)+0 > max+0) max=$(NF-1)} {a+=$(NF-1)} {if ($5 == 408) b+=1} {if ($5 != 200 && $5 != 408) c+=1} END {print  $4","NR","a/NR","b","c","max}' >> ${ANAL_FILE}result.temp

cd ${ANAL_DIR}
find ./  -mtime  +10 -exec rm -rf {} \;
find ./ -depth -empty -type d -exec rmdir -v {} \;
