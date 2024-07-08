#!/bin/bash

# 定义新的代理 IP 和端口
NEW_PROXY_IP="192.168.188.122"
PROXY_PORT="7890"

# 设置 HTTP 和 HTTPS 代理环境变量
export http_proxy="http://$NEW_PROXY_IP:$PROXY_PORT"
export https_proxy="http://$NEW_PROXY_IP:$PROXY_PORT"
export ftp_proxy="http://$NEW_PROXY_IP:$PROXY_PORT"
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

# 更新 apt 的代理配置
APT_CONF="/etc/apt/apt.conf.d/proxy.conf"
echo "Acquire::http::Proxy \"http://$NEW_PROXY_IP:$PROXY_PORT/\";" | sudo tee $APT_CONF
echo "Acquire::https::Proxy \"http://$NEW_PROXY_IP:$PROXY_PORT/\";" | sudo tee -a $APT_CONF

# 更新 pip 的代理配置
PIP_CONF="$HOME/.pip/pip.conf"
mkdir -p $(dirname $PIP_CONF)
echo "[global]" > $PIP_CONF
echo "proxy = http://$NEW_PROXY_IP:$PROXY_PORT" >> $PIP_CONF

# 更新 Poetry 的代理配置
POETRY_CONFIG="$HOME/.config/pypoetry/config.toml"
mkdir -p $(dirname $POETRY_CONFIG)
echo "[http]" > $POETRY_CONFIG
echo "proxy = \"http://$NEW_PROXY_IP:$PROXY_PORT\"" >> $POETRY_CONFIG
echo "[https]" >> $POETRY_CONFIG
echo "proxy = \"http://$NEW_PROXY_IP:$PROXY_PORT\"" >> $POETRY_CONFIG

# 确认代理设置
echo "HTTP Proxy: $http_proxy"
echo "HTTPS Proxy: $https_proxy"
echo "APT Proxy Configuration:"
cat $APT_CONF
echo "PIP Proxy Configuration:"
cat $PIP_CONF
echo "Poetry Proxy Configuration:"
cat $POETRY_CONFIG

echo "Proxy settings have been updated."

source ~/.bashrc
