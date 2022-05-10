# minidlna-docker

Credit to Jacob Alberty and the [unifi-docker](https://github.com/jacobalberty/unifi-docker) project for providing an excellent example of how to construct a Dockerfile and associated shell scripts.

## Description

This is a containerized version of the [ReadyMedia](http://minidlna.sourceforge.net/) media server software. [Arch Linux](https://archlinux.org/) has a description of the software here https://wiki.archlinux.org/title/ReadyMedia, and man page here https://man.archlinux.org/man/community/minidlna/minidlnad.8.en.

Edit `minidlna.conf` to include the directories to serve, then run `docker-build.sh`.

For example, to serve audio files from `/srv`, add this line to `minidlna.conf`:
```
media_dir=A,/srv
```

You may also want to set the name that the server advertises and shorten the push notification from the server:
```
friendly_name=Media Server
notify_interval=10  # seconds
```

## Docker Configuration
The ReadyMedia server advertises the service with muticast [SSDP](https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol) packets. The default `bridge` network doesn't pass multicast packets so we will create an [`ipvlan`](https://docs.docker.com/network/ipvlan/) network.

```
# docker create network -d ipvlan -o parent eth0 --subnet 192.168.0.0/16 --gateway 192.168.0.1 --ip-range 192.168.10.0/24 ipvlan_net
```

A few things to note:

* Replace `eth0` with the name of your LAN network adapter
* Replace IP addresses with values appropriate for your network.

Build and run the container:
```
# ./docker-build.sh > build.log
# docker-run -it --rm -v /var/lib/minidlna:/var/lib/minidlna -v /srv:/srv --net ipvlan_net --name minidlna iboisvert/minidlna-docker:1
```

Note that it isn't necessary to publish ports exposed by the container.

## Environment Variables

### MINIDLNAD_UID

Default: 999

Specify which user `minidlnad` should run as, instead of root; user can either be a numerical UID or a user name.

### HTTP_PORT

Default: 8200

Port for HTTP (descriptions, SOAP, media transfer) traffic etc.

## Ports

### `$HTTP_PORT`/tcp

Port for HTTP (descriptions, SOAP, media transfer) traffic etc.

### 1900/udp

Device search requests and advertisements are supported by running HTTP on top of UDP (port 1900) using multicast (known as HTTPMU).

## Volumes

### `/var/lib/minidlna`

Path to the directory minidlnad should use to store its database and album art cache.