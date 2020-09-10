#!/bin/sh

cp /usr/local/tunnel/cert/clientcert.pem /tmp/clientcert.pem
chmod 600 /tmp/clientcert.pem

while [ 1 ] ; do
  echo "[`date`] Connecting SSH tunnel ${REMOTEHOST}:${LISTENPORT} => ${HOST}:${PORT}"
  ssh -o ServerAliveInterval=15 -o StrictHostKeyChecking=accept-new -g -N -R *:${LISTENPORT}:${HOST}:${PORT} -i /tmp/clientcert.pem ${USER}@${REMOTEHOST}
  sleep 5
done