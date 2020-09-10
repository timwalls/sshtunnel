#!/bin/sh

while [ 1 ] ; do

  ssh -g -N -R ${LISTENPORT}:${HOST}:${PORT} -i /usr/local/tunnel/cert/clientcert.pem ${USER}@${REMOTEHOST}

done