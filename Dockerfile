# LTS
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# apt-get update & localize & install JP font
RUN apt-get update && apt-get -y install locales \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
    && apt install -y --no-install-recommends fonts-noto-cjk
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

# add user
RUN apt-get -y install sudo
ARG USERNAME=admin
ARG PASSWORD=admin
ARG UID=1000
RUN useradd -m -s /bin/bash -u ${UID} -G sudo ${USERNAME} \
    && echo ${USERNAME}:${PASSWORD} | chpasswd \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install dependent package
RUN apt-get -y install vim iputils-ping net-tools wget curl \
    npm build-essential cmake clang libaio1 libffi-dev libfreetype-dev libpq-dev

# install certificate
RUN sudo apt-get install -y --reinstall ca-certificates

# install pyenv
RUN sudo apt-get install -y --no-install-recommends git \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev llvm libncurses5-dev xz-utils
RUN mkdir -p /exec/.pyenv
RUN git clone https://github.com/pyenv/pyenv.git /exec/.pyenv \
    && cd /exec/.pyenv && src/configure && make -C src
ENV PYENV_ROOT="/exec/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# install python with pyenv
RUN pyenv install 3.12.3 && \
    pyenv global 3.12.3
ENV PATH="$PYENV_ROOT/versions/3.12.3/bin:$PATH"

# install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"
RUN poetry config virtualenvs.in-project true

# install jupyterhub + jupyterlab
RUN npm install -g configurable-http-proxy \
    && mkdir -p /exec/venvs/jupyter
COPY init/exec/venvs/jupyter/pyproject.toml /exec/venvs/jupyter
RUN cd /exec/venvs/jupyter && poetry install --no-root
COPY init/etc/jupyterhub/jupyterhub_config.py /etc/jupyterhub/
COPY init/etc/jupyterhub/jupyter_notebook_config.py /etc/jupyterhub/
COPY init/etc/jupyterhub/jupyter_run.sh /etc/jupyterhub/

# virturlenv sample
RUN mkdir -p /exec/venvs/sample
COPY ./init/exec/venvs/sample/pyproject.toml /exec/venvs/sample/
RUN cd /exec/venvs/sample/ \
    && poetry install --no-root \
    && poetry run python -m ipykernel install --name=sample

# add user script files
COPY init/etc/jupyterhub/add_user.sh /etc/jupyterhub/
RUN chmod 775 /etc/jupyterhub/add_user.sh

# ログ管理場所作成
RUN mkdir -p /var/log/jupyterhub