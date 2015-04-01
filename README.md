# HA Proxy
This container builds on hpess/chef by adding HAProxy, currently version 1.5.11 (built from source).

## Use
Out of the box, it doesn't do a huge amount.  HA Proxies configuration is going to be pretty bespoke per implementation so I haven't attempted to do any form of templating, subsequently this container __will not boot__ unless you put your own `haproxy.cfg` into `/storage` via either a bindmount or new Dockerfile.

This is an example docker file for load balancing an ELK stack..
```
haproxy:
  image: hpess/haproxy:master
  restart: always
  hostname: haproxy
  volumes:
    - ./storage/haproxy:/storage
  ports:
    - "9300:9300/tcp"   # Elasticsearch
    - "9200:9200/tcp"   # Elasticsearch
    - "5601:5601/tcp"   # Kibana
    - "1337:1337/tcp"   # Logstash TCP connector
  links:
    - "elasticsearch1"
    - "elasticsearch2"
    - "logstash1"
    - "logstash2"
    - "kibana1"
    - "kibana2"
```
Then you'll need to create `./storage/haproxy` and stick your `haproxy.cfg` into there.

## Optimizations 
The following flags were used during complication:
  - USE_PCRE=1: HAProxy recommended configuration
  - USE_LIBCRYPT=1: Support encrypted passwords in config
  - USE_LINUX_SPLICE=1: Enables support for the splice() system call, to enable data to be moved between file descriptors within kernel space, not touching the user space.
  - USE_LINUX_TPROXY=1: Enable support for linux transparent proxy.

## License
This docker application is distributed unter the MIT License (MIT).

HAProxy itself is licenced under the [GPL V2](http://www.haproxy.org/download/1.3/doc/LICENSE) License.
