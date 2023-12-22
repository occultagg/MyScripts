#!/bin/bash

# 安装常用工具和开发环境
yum -y install net-tools telnet vim git lrzsz tcpdump
yum -y groupinstall 'development tools' 'server platform development'
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python get-pip.py
# 修改pip源
cd /root/
mkdir ./.pip
cat > ./.pip/pip.conf << EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
pip install --upgrade pip
# 剔除firewalld和NetworkManager
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
# 安装启动iptables
yum -y install iptables-services iptables-devel
systemctl start iptables
systemctl enable iptables
# 关闭selinux
setenforce 0
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
# vim配置
cat > /root/.vimrc << EOF
"行数显示
set nu
"自动识别文件编码
"依照fileencodings提供的编码列表尝试，如果没有找到合适的编码，就用latin-1(ASCII)编码打开
set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936
""设置tab为4个空格
set ts=4
set expandtab
"模板设置 .tlp模版文件中写入你想vim自动填入的内容
let g:enable_template = 1
let g:template_dir = "~/.vim/templates"
autocmd BufNewFile *.sh  0r  ~/.vim/template/sh.tlp
autocmd BufNewFile *.py  0r  ~/.vim/template/py.tlp
EOF
mkdir -p /root/.vim/template/
cat > ~/.vim/template/sh.tlp << EOF
#!/bin/bash
#
EOF
cat > ~/.vim/template/py.tlp << EOF
# conding=utf-8
#
EOF

#时间同步阿里云时间服务器
yum -y install chrony
sed -i 's/0.centos.pool.ntp.org/ntp1.aliyun.com/' /etc/chrony.conf
sed -i 's/1.centos.pool.ntp.org/ntp2.aliyun.com/' /etc/chrony.conf
sed -i 's/2.centos.pool.ntp.org/ntp3.aliyun.com/' /etc/chrony.conf
sed -i 's/3.centos.pool.ntp.org/ntp4.aliyun.com/' /etc/chrony.conf
systemctl start chronyd
systemctl enable chronyd

#修改时区
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
