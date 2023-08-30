# Gyazo

This is a private Gyazo server works on sinatra.  
It provides not only upload function but image gallery.

## Sample settings

### nginx.conf

Nginx works as a reverse proxy.

```
upstream foo.bar {
    server 127.0.0.1:8000;
}

server {
    listen      80;
    server_name foo.bar;

    root    /path/to/gyazo;

    location / {
        proxy_pass http://foo.bar/;
    }

    location ~ ^/([0-9a-zA-Z]+\.(?:gif|jpg|png)$) {
        alias /path/to/gyazo/data_dir/$1;
    }

    location ~ ^/common/(.*$) {
        alias /path/to/gyazo/common/$1;
    }
}
```

### FreeBSD rc.d script

Gyazo server starts by rackup command.

```sh
#!/bin/sh
#
# PROVIDE: rackup
# REQUIRE: nginx
# KEYWORD: shutdown

. /etc/rc.subr

name="rackup"
rcvar=rackup_enable
command="/path/to/rackup"
port="8000"
target="/path/to/gyazo/config.ru"
pidfile="/var/run/${name}.pid"
command_args="-p $port -D -P $pidfile $target"

load_rc_config $name
run_rc_command "$1"
```

## Thanks

- https://github.com/gyazo/Gyazo
- https://github.com/ed-lea/jquery-collagePlus
