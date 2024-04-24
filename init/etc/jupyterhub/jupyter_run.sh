cd /exec/venvs/jupyter \
&& poetry run jupyterhub -f /etc/jupyterhub/jupyterhub_config.py >> /var/log/jupyterhub/jupyterhub.log 2>&1