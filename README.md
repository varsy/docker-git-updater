docker-git-updater
==================

Container for pulling git repo in cycle and notify etcd about changes.

### List of environment variables

* `GITPATH` path to git repository.
* `LOCALPATH` path to folder where git repository would be cloned. Optional, default is `/data`.
* `ETCDCTL_PEERS` parameter to tell `etcd` peer address to work with.
* `ETCDCTL_WATCH` path inside etcd to watch update signal. Optional, refer to [`varsy/crond`](https://registry.hub.docker.com/u/varsy/crond/) Default: `/services/crond/notify` 
* `ETCDCTL_NOTIFY` path inside etcd to send notification signal if git repo have changed. 

### SSH private keys
You may need to access private GIT repository with confd config files. In such case you have put ssh config file and private key to folder `/sshconfig`.
It can be done by the small secure data container on the same docker host and param `--volumes-from=ssh-config-container` for your container.
