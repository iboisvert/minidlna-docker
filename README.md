# minidlna-docker

Credit to Jacob Alberty and the [unifi-docker](https://github.com/jacobalberty/unifi-docker) project.

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

Build and run the container:
```
# ./docker-build.sh
# docker-run --rm -p 8200:8200/tcp -p 1900:1900/udp -v /var/lib/minidlna:/var/lib/minidlna -v /srv:/srv --name minidlna iboisvert/minidlna:1
```

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