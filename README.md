# syslog-ng with installed Rust modules

This Docker image contains syslog-ng with Rust modules installed.

Currently the only notable Rust module is the actiondb parser binding.

## actiondb parser

You can find detailed information about the pattern format in GitHub:
https://github.com/ihrwein/actiondb

This Docker image starts syslog-ng with the following configuration parameters:
* syslog-ng listens on the 1514 TCP port
* syslog-ng's configuration file (`syslog-ng.conf`) is under `/config`
* actiondb parser's pattern file (`patterns.json`) is under `/config`
* actiondb prepend the prefix `.adb` before every parsed key-value pair
* the parsed log messages are written into the file `/output/parsed.json`

Every parsed key-value pair will be inserted into the parsed logmsg. You can
set a prefix which will be prepended before every key-value pair with the
`prefix` option (check the example syslog-ng.conf).

The parser also adds the matching pattern name and it's UUID to the logmsg:
* `.classifier.name`: the name of the pattern (optional)
* `.classifier.uuid`: the UUID of the pattern

If you set a `prefix` it will be appended before these keys.

### Default behavior
The image contains patterns for loggen by default. With the following command you can test the default behavior:

1. Start a container:

```
sudo docker run -v $(pwd):/output  -p 1514:1514 ihrwein/syslog-ng-rust -evd
```
2. Use loggen to send some messages:

```
loggen -S -n 10 127.0.0.1 1514
```

3. Check the ouput file in the current folder:

```
cat parsed.json
```

### Tweaking

You can run the container with the following command:

```
sudo docker run -p 1514:1514 ihrwein/syslog-ng-rust
```

It will start syslog-ng in foreground mode (`-F`). You can supply additional command
line parameters:

```
sudo docker run -p 1514:1514 ihrwein/syslog-ng-rust -evd
```

You can mount your own syslog-ng configuration into the container:

```
sudo docker run -v $(pwd)/syslog-ng.conf:/config/syslog-ng.conf -p 1514:1514 ihrwein/syslog-ng-rust -evd
```

You can even use your own pattern file with the actiondb parser:

```
sudo docker run -v $(pwd)/patterns.json:/config/patterns.json  -p 1514:1514 ihrwein/syslog-ng-rust -evd
```

You can mount an output directory into the container so the parsed logs will be
visible from outside (`parsed.json` file):

```
sudo docker run -v $(pwd):/output -p 1514:1514 ihrwein/syslog-ng-rust
```


# Supported ActionDB versions

`actiondb-0.2.1`
