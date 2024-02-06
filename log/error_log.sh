#!/bin/bash

LOG_PATH=/mydata/product/eoc/nginx/nginx/logs/error.log
RESULT_DIR=/mydata/product/eoc/nginx/nginx/sbin/error_anal/
WEEKLY_REPORT=weekly_error.log
RESULT=${RESULT_DIR}error_result_NGINX61.csv

L_MONTH=`date --date='1 month ago' +%m`
T_MONTH=`date +%m`
S_DAY=`date --date='7 days ago' '+%d'`
E_DAY=`date '+%d'`

#截取一周的错误日志
awk -F'/' '{if ($2 == L_M || $2 == T_M) print $0}' L_M="$L_MONTH" T_M="$T_MONTH" ${LOG_PATH} | awk '-F[/ ]' '{if (($3 >= s || $3 < e) && $5 == "[error]") print $0}' s="$S_DAY" e="$E_DAY" > ${WEEKLY_REPORT}

printf "\xEF\xBB\xBF" > ${RESULT}

#一周总错误数
echo '一周总错误数' >> ${RESULT}
cat ${WEEKLY_REPORT} | wc -l >> ${RESULT}

#错误类型统计
echo '错误类型统计' >> ${RESULT}
awk -F',' '{print $1}' ${WEEKLY_REPORT} | sort | awk -F' ' '{for (i=6;i<=NF;i++) printf $i ""FS;print""}' | sort | uniq -c | sort -nrk 1 >> ${RESULT}

awk -F',' '{print $1}' ${WEEKLY_REPORT} | sort | awk -F' ' '{for (i=6;i<=NF;i++) printf $i ""FS;print""}' | sort | uniq > temp

while read LINE
do
	echo "###" >> ${RESULT}
	echo "##'${LINE}'##的错误统计" >> ${RESULT}
	#请求错误数
	echo '请求错误数' >> ${RESULT}
	grep "${LINE}" ${WEEKLY_REPORT} | awk -F',' '{print $4}' | awk -F'[ ?]' '{print $2 $3 $4","$NF}' | sort | uniq -c | sort -nrk 1  >> ${RESULT}
	echo '上层接口错误数' >> ${RESULT}
	grep "${LINE}" ${WEEKLY_REPORT} | awk -F',' '{print $5}' | awk -F'?' '{print $1}' | sort | uniq -c | sort -nrk 1 >> ${RESULT}
	echo '主机错误数' >> ${RESULT}
	grep "${LINE}" ${WEEKLY_REPORT} | awk -F',' '{print $6}' | sort | uniq -c | sort -nrk 1 >> ${RESULT}
done < temp

rm -rf temp
rm -rf ${WEEKLY_REPORT}


