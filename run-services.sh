#!/bin/sh

trap "killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

if [ -z "${ETCD_NOTIFY}" ] ; then
     ETCD_NOTIFY=/services/gitupdater/notify
fi

if [ -z "${LOCALPATH}" ] ; then
     LOCALPATH=/data
fi

if [ ! -z "${GITPATH}" ] ; then
    rm -rf ${LOCALPATH}
    echo "Cloning ${GITPATH} repo to ${LOCALPATH}"
    RETVAL=-1
    while [ ${RETVAL} -ne 0 ]; do
	git clone ${GITPATH} ${LOCALPATH}
	let RETVAL=$?
	sleep 5
    done
else
    echo "Error: can't find GITPATH, exiting."
    exit 1
fi

set | grep -E "ETCDCTL_PEERS|LOCALPATH|GITPATH|ETCD_NOTIFY" > /etc/sysconfig/vars



touch /var/log/container.log
tail -F /var/log/container.log &

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    /reloader.sh ${ETCDCTL_WATCH} &
fi
wait



