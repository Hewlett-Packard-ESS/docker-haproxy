FROM hpess/chef:master
MAINTAINER Karl Stoney <karl.stoney@hp.com> 

RUN yum -y install make gcc gcc-c++ pcre-devel && \
    yum -y clean all

RUN cd /tmp && \
    wget http://www.haproxy.org/download/1.5/src/haproxy-1.5.11.tar.gz && \
    tar -xzf haproxy-* && \
    cd haproxy-* && \
    make TARGET=custom USE_PCRE=1 USE_LIBCRYPT=1 USE_LINUX_SPLICE=1 USE_LINUX_TPROXY=1 && \
    make install && \
    rm -rf /tmp/haproxy*

COPY services/* /etc/supervisord.d/

# Setup the environment
ENV HPESS_ENV haproxy
