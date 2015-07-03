# Actiondb parser for syslog-ng

Clone this repo, step into it, then:

```
sudo docker build --tag syslog-ng-actiondb .
```

It will take for a while because a lot of dependencies are installed (and compiled).

When the build finished you can start a container with the following command:

```
sudo docker run -it -p 1514:1514 syslog-ng-actiondb /bin/bash
```

It will redirect the `1514` TCP port on the host to the container and start a new shell.
Start syslog-ng in the container:

```
root@b4dcf44938b4:~/install/syslog-ng# sbin/syslog-ng -Fevd
```

Then in a new terminal you can use `loggen` to send messages to the `1514` port. The Docker image
has a pattern for loggen messages so they will be parsed immediately and got written into
the file `/tmp/loggen.log` (in the container).

You can mount directories from the host into the container with the `-v` parameter. This way, you
can use this container to parse your logs without even installing Rust and syslog-ng.
