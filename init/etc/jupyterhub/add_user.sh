#!/bin/bash
USERNAME="${1}"
PASSWORD="password"

# ユーザー追加、パスワード固定
sudo adduser -q --gecos "" --disabled-password ${USERNAME}
echo "${USERNAME}:${USERNAME}" | sudo chpasswd

# sudoグループに追加
gpasswd -a ${USERNAME} sudo