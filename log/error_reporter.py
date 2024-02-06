#!/usr/bin/env Python
# -*- coding=utf-8 -*-

import subprocess
import csv
import datetime

from email.mime.text import MIMEText
from email import encoders
#改变编码支持中文
from email.header import Header
#格式化发件人、收件人
from email.utils import parseaddr, formataddr
#附件支持
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication 
import smtplib


def getYesterday(): 
	today=datetime.date.today() 
	oneday=datetime.timedelta(days=1) 
	yesterday=today-oneday 
	return str(yesterday)

def _format_addr(s):
	name, addr = parseaddr(s)
	return formataddr((Header(name, 'utf-8').encode(), addr))


def sent_mail(yesterday):
	from_addr = 'panweijian@e-car.cn'
	password = '7705My00'
	to_addr = ['pengxinming@e-car.cn','panweijian@e-car.cn']
	#to_addr = ['panweijian@e-car.cn', '419397705@qq.com', '1540060183@qq.com']
	smtp_server = 'smtp.exmail.qq.com'
	#建立MIMEmultipart对象
	msg = MIMEMultipart()
	msg['From'] = _format_addr(from_addr)
	msg['To'] = _format_addr(to_addr)
	msg['Subject'] = Header(yesterday + 'nginx错误日志统计', 'utf-8').encode()
	text = MIMEText('你们好，附件为上周的nginx错误日志统计。', 'plain', 'utf-8')
	msg.attach(text)
	filename = '/root/log-report/error/' + yesterday + '.zip'
	atta = MIMEApplication(open(filename,'rb').read())
	atta.add_header('Content-Disposition', 'attachment', filename=yesterday + '.zip')
	msg.attach(atta)

	server = smtplib.SMTP(smtp_server, 25)
	#打印出和smtp交互的信息
	server.set_debuglevel(1)
	server.login(from_addr, password)
	server.sendmail(from_addr, to_addr, msg.as_string())
	server.quit()


def main():
	yesterday = getYesterday()
	sh_path = '/root/log-report/error_report.sh'
	p = subprocess.Popen(sh_path, shell=True)
	ret = p.wait()
	if ret != 0:
		print('脚本执行错误')
	else:
		sent_mail(yesterday)


if __name__ == '__main__':
	main()
		
