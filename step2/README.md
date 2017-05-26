This chart deployes a CentOS 7 based shell container loaded up with a 
collection of utilities.

The resulting container is meant to be used as a workspace / jumpbox within
a K8S-hosted nLighten deployment.  It contains many useful utilities, 
including:

* standard Unix network tools (traceroute, netcat / socat, httpie)
* interpreters (Python, Ruby)
* Kubernetes utilities (kubectl, helm)
* DNS utilities (dig, host)
* Remote access / session sharing (teleconsole, screen, tmux)

Use of the jumpbox is via `kubectl exec` or `kubectl attach`.

The default deployment has replicas=0 to conserve cluster resources. In
other words, the deployment will exist, but no pods will have been created.
To create one or more, execute a `kubectl scale` command.

A PVC with storageclass "default" will be created and mounted at /home/jumpbox.
Even if you scale the box down to 0, your working files stored there will be
present at next scale-up.

Note that if you scale past replicas=1, and use the included ReadWriteOnce PVC, 
subsequent pods *may* fail to launch, depending on the volume driver. Kubernetes 
does not itself appear to enforce the "single mounter" nature of a ReadWriteOnce 
PVC. The actual storage system may do so.

See the NOTES.txt (shown at `helm install` or `helm status`) for specific commands
to issue to connect.

See ACME-918 for history.
