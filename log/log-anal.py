#!/usr/bin/python3

import subprocess
import csv
import datetime

def getYesterday(): 
    today=datetime.date.today() 
    oneday=datetime.timedelta(days=1) 
    yesterday=today-oneday 
    return str(yesterday)

def create_csv(anal_file):
	with open(anal_file, 'w', encoding='utf-8-sig') as csvfile:
		writer = csv.writer(csvfile)
		data = ['\ufeffURL', '日访问量', '平均调用时长（S）', '超时次数（408）', '错误次数（除去408）', '访问最大时长（S）']
		writer.writerow(data)

def main():
	yesterday = getYesterday()
	anal_file = '/mydata/product/eoc/nginx/nginx/sbin/anal_file/' + yesterday + '/NGINX_61.csv'
	result_temp = '/mydata/product/eoc/nginx/nginx/sbin/anal_file/' + yesterday + '/result.temp'
	sh_path = '/mydata/product/eoc/nginx/nginx/sbin/log-anal.sh'
	p = subprocess.Popen(sh_path, shell=True)
	ret = p.wait()
	if ret != 0:
		print('error')
	else:
		create_csv(anal_file)
		with open(result_temp, 'r') as result:
			for each_line in result:
				log_line = each_line.strip('\n').split(',')
				with open(anal_file, 'a+', encoding='utf-8-sig') as al:
					writer = csv.writer(al)
					writer.writerow(log_line)


if __name__ == '__main__':
	main()
