# environment_jupyter_docker

## Description
Docker上にJupyterHub+JupyterLabと実行環境を構築するための構成を作成しました。
Pythonのバージョンはpyenvで、仮想環境はPoetryでそれぞれ管理します。
JupyterHubとJupyterLabはPoetryの仮想環境内にインストールします。
JupyterHubの起動簡略化のためのコマンドを作成してます。

## Usage
```shell
# build
docker-compose up -d --build

# attach
docker exec -it env-jupyter-docker bash

# run JupyterHub
source /etc/jupyterhub/jupyter_run.sh
```