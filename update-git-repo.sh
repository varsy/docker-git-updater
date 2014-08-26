#!/bin/bash
. /etc/sysconfig/vars
export ETCDCTL_PEERS=${ETCDCTL_PEERS}
export LOCALPATH=${LOCALPATH}
export GITPATH=${GITPATH}
export ETCD_NOTIFY=${ETCD_NOTIFY}

# Check: if no GIT repo here - no need to pull it
if [ ! -d ${LOCALPATH}/.git ] ; then
    exit 0
fi

CHANGED=0
cd ${LOCALPATH}/
git pull | grep -q -v 'up-to-date' && CHANGED=1

if [ $CHANGED -eq 1 ]; then
    echo "`date +%Y-%m-%d-%H%M%S` - Git repo was changed" >> /var/log/container.log
    etcdctl set ${ETCD_NOTIFY} updated
fi
