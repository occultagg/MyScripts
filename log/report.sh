#!/bin/bash

# 陈锦秋&侯明波 
# NGINX_153 119.29.104.153 
# NGINX_61 119.29.16.61 
# NGINX_81 119.29.23.81 

# 许文举
# 192.168.2.100 
# 118.89.37.123   /usr/local/nginx/   /opt/nginx/nginx/logs/
# 118.89.58.94

YESTERDAY=`date -d yesterday +%Y-%m-%d`

#陈锦秋3台日志路径
C_LOGPATH=/mydata/product/eoc/nginx/nginx/sbin/anal_file/${YESTERDAY}
#许文举的日志路径
#2.100日志路径
#X_LOGPATH_101=/opt/prod_nginx/nginx/sbin/anal_file/${YESTERDAY}
X_LOGPATH_111=/opt/nginx/nginx/sbin/anal_file/${YESTERDAY}
#58.94日志路径
X_LOGPATH_94=/usr/local/nginx/sbin/anal_file/${YESTERDAY}
#37.123日志路径
X_LOGPATH_123_1=/usr/local/nginx/sbin/anal_file/${YESTERDAY}
X_LOGPATH_123_2=/opt/nginx/nginx/sbin/anal_file/${YESTERDAY}


REPORT_PATH='/root/log-report'

cd ${REPORT_PATH} 

#复制分析文件
if [ ! -d ${YESTERDAY} ];then
    mkdir ${YESTERDAY}
fi
#
/usr/bin/scp root@119.29.104.153:${C_LOGPATH}/*.csv ./${YESTERDAY}
/usr/bin/scp root@119.29.16.61:${C_LOGPATH}/*.csv ./${YESTERDAY}
/usr/bin/scp root@119.29.23.81:${C_LOGPATH}/*.csv ./${YESTERDAY}
#
/usr/bin/scp root@192.168.2.111:${X_LOGPATH_111}/*.csv ./${YESTERDAY}
/usr/bin/scp root@118.89.58.94:${X_LOGPATH_94}/*.csv ./${YESTERDAY}
/usr/bin/scp root@118.89.37.123:${X_LOGPATH_123_1}/*.csv ./${YESTERDAY}
/usr/bin/scp root@118.89.37.123:${X_LOGPATH_123_2}/*.csv ./${YESTERDAY}

/usr/bin/zip ${YESTERDAY}.zip ./${YESTERDAY}/*
rm -rf ./${YESTERDAY}
find ./ -name "*.zip" -mtime  +4 -exec rm -rf {} \;


