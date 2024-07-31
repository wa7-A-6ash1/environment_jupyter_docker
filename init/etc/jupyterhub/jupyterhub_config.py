c = get_config()  # noqa
c.LocalAuthenticator.create_system_users=True
c.LocalAuthenticator.add_user_cmd=['sh', '/etc/jupyterhub/add_user.sh']
c.PAMAuthenticator.admin_groups = {'sudo'}

import netifaces

c.JupyterHub.hub_connect_ip = netifaces.ifaddresses('eth0')[netifaces.AF_INET][0]['addr']
c.JupyterHub.hub_id = '0.0.0.0'
c.Spawner.default_url = '/lab'
c.Authenticator.admin_users={'admin'}
