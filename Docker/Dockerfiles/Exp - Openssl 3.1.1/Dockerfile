FROM alpine:edge

RUN set -x \
    && apk add --no-cache \
    bash \
    wget \
    gcc \
    tar \
    alpine-sdk \
    perl \
    tcpdump \ 
    linux-headers \
    && rm -rf /var/cache/apk/*

ENV OPENSSL_VERSION="3.1.1"

COPY ./openssl-${OPENSSL_VERSION} /tmp/openssl-${OPENSSL_VERSION}

RUN set -x \
    ### BUILD OpenSSL
    && cd /tmp/openssl-${OPENSSL_VERSION} \
    && sed -i 's/-DTERMIO /-DTERMIOS /g' ./Configure \ 
    && sed -i 's/# define TERMIO$/# define TERMIOS/g' crypto/ui/ui_openssl.c \
    && sed -i 's/# define SGTTY$/# undef SGTTY/g' crypto/ui/ui_openssl.c \
    && ./Configure linux-x86_64 shared enable-ecdsa\
    && make depend\
    && make \
    && make all install_sw \
    && cd .. \
    && rm -rf openssl-${OPENSSL_VERSION}

ENV PATH /usr/local/ssl/bin:$PATH