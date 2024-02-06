#!/bin/bash
#version: 1.1
#description: Nginx logrotate
#date:20161121
#author:by yguo
#moditied: by pwj

YESTERDAY=`date -d yesterday +%Y%m%d`
LOGPATH=/mydata/product/eoc/nginx/nginx/logs/
OLDLOG=/mydata/product/eoc/nginx/nginx/logs/oldlog/$YESTERDAY/
OLDLOGDIR=/mydata/product/eoc/nginx/nginx/logs/oldlog
#PIDFILE=`ps aux | grep "nginx: master process" | grep -v "grep" | awk '{print $2}'`
NGINXPATH=/mydata/product/eoc/nginx/nginx/sbin/

if [ ! -d ${OLDLOG} ] ; then
    mkdir -p ${OLDLOG}
fi
    mv ${LOGPATH}host.access.log ${OLDLOG}host.access_${YESTERDAY}.log

#kill -USR1 ${PIDFILE}
${NGINXPATH}nginx -s reload

cd ${OLDLOGDIR} 
find ./ -mtime +7 -exec rm -rf {} \;
find ./ -depth -empty -type d -exec rmdir -v {} \;
