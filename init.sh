#!/bin/bash

# 安装git和gcc
yum install -y git
yum install -y gcc-c++.x86_64 

# 安装supervisor
yum install -y pip
pip install supervisor

if [ ! -f "/etc/supervisord.conf" ]; then
    echo "创建supervisord配置..." 
    echo_supervisord_conf > /etc/supervisord.conf
    echo "[include]" >> /etc/supervisord.conf
    echo "files = $HOME/algobeatscpp/algobeats/config/*.conf" >> /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi

if [ ! -d "static_libs" ]; then
    git clone https://github.com/koane/static_libs.git
fi

if [ ! -d "static_libs" ]; then
    echo "错误: 拉取代码失败"
    exit 1
fi

# 链接库
if [ ! -f "/usr/lib64/libssl.so" ]; then
    echo "拷贝静态库..."
    cp ./static_libs/*so /usr/lib64/
    cp /usr/lib64/libssl.so /usr/lib64/libssl.so.10
    cp /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.10
fi

# 清理文件
rm -rf ./static_libs

echo "配置完成 supervisor默认配置文件夹:$HOME/algobeatscpp/algobeats/config/ 编辑配置文件"
echo "如需修改supervisor配置 请修改/etc/supervisord.conf文件并重启supervisor"

