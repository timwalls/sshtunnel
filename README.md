# sshtunnel
An absolute horrorshow - a Docker container that encapsulates an SSH tunnel.

## My eyes!  Why!?
Well...  I need a poor-man's VPN whose only job is to expose a port on my
internal Kubernetes cluster to the outside world, via a machine hosted in
the cloud.

## What?
Basically, I don't want to expose my home IP address to the Intarwebs as a
server, and I don't want to fiddle around with Dynamic DNS either.  This
solves both - I have a tiny VM image on AWS that is just an endpoint for the
SSH tunnel, and use port-forwarding to forward the port I want made public
back to my cluster.

# How To Use
With shame.

## No, really
You need to provide the following environment variables:

| Variable | Value/Meaning |
| -------- | ------------- |
| REMOTEHOST | The remote machine to log in to |
| USER       | The username to log in to the remote host with |
| LISTENPORT | The port the remote machine should listen for connections on |
| HOST       | The local host connections should be forwarded to |
| PORT       | The port on the local host to forward to |

You will also need to provide an SSH client certificate in `/usr/local/tunnel/cert/clientcert.pem`.
You can do this using either a Volume mount or by extending the Docker image
and copying a certificate into place.

## I want to do the bad thing on Kubernetes
Create a Secret with your certificate in, something like this:
```
apiVersion: v1
kind: Secret
metadata:
  name: tunnel-secret
type: Opaque
stringData:
  clientcert.pem: |
    -----BEGIN RSA PRIVATE KEY-----
    /// INSERT PRIVATE KEY HERE ///
    -----END RSA PRIVATE KEY-----
```

Then you can make a deployment with the sshtunnel container that looks
something like this:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tunnel
  labels:
    app: sshtunnel
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sshtunnel
  template:
    metadata:
      labels:
        app: sshtunnel
    spec:
      containers:
      - name: sshtunnel
        image: snowgoons/sshtunnel:latest
        env:
        - name: REMOTEHOST
          value: "myremotehost"
        - name: USER
          value: "myusername"
        - name: LISTENPORT
          value: "1234"
        - name: HOST
          value: "mylocalendpoint"
        - name: PORT
          value: "1234"
        volumeMounts:
        - name: clientcert
          mountPath: "/usr/local/tunnel/cert"
          readOnly: true
      volumes:
      - name: clientcert
        secret:
          secretName: tunnel-secret

```


