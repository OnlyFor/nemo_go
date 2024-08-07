#!/bin/bash

# 检查daemon文件是否存在
if [ -f "daemon_worker_linux_amd64" ];then
  echo "check daemon_worker_linux_amd64 exist..."
  chmod +x daemon_worker_linux_amd64
  else
  echo "check daemon_worker_linux_amd64 not exist,exit..."
  exit
fi
# 更新相关的依赖
read -r -p "start check update and install dependence? [Y/n]: " sure
if [ -z "$sure" ];then
    sure="y"
fi
case "$sure" in
    y|Y)
        # apt update && upgrade
        sudo apt-get update  && sudo apt-get install vim nmap masscan curl --fix-missing -y
        nemo_pwd=$(pwd)
        cd /usr/bin && sudo chown root nmap masscan && sudo chmod u+s nmap masscan
        cd "$nemo_pwd" || exit
        curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb  && sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb && rm /tmp/google-chrome-stable_current_amd64.deb
        ;;
    n|N)
        echo "skip..."
        ;;
esac
# 创建一些必要的目录
mkdir conf && mkdir log && mkdir -p thirdparty/massdns/temp
# 从server同步文件
echo "start to sync from server...."
# sync from server
read -r -p "input server ip: " server_ip
if  [ -z "$server_ip" ] ;then
    echo "you have not input server ip!"
    exit
fi
read -r -p "input server sync port: " server_port
if  [ -z "$server_port" ] ;then
    echo "you have not input server sync port!"
    exit
fi
read -r -p "input server sync key: " sync_key
if  [ -z "$sync_key" ] ;then
    echo "you have not input server sync key!"
    exit
fi
read -r -p "use tls? [y/n]: " tls
if  [ "$tls" = "y" ] ;then
    tls="-tls"
    else
    tls=""
fi
./daemon_worker_linux_amd64 $tls -mh "$server_ip" -mp "$server_port" -ma "$sync_key"
echo "install success!"