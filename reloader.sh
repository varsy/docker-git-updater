#!/bin/sh

ETCDCTL_WATCH=/services/crond/reload
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    
    if [ "${RESULT}" == "reload" ] ; then
	echo "`date +%Y-%m-%d-%H%M%S` - Catched reload action. Reloading..." >> /var/log/container.log
	/update-git-repo.sh
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done