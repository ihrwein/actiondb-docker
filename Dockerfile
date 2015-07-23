FROM ubuntu:14.04

ENV PKG_CONFIG_PATH /root/install/syslog-ng/lib/pkgconfig
ENV SYSLOG_NG_INSTALL_DIR /root/install/syslog-ng
ENV ACTIONDB_RELEASE actiondb-0.1.0

RUN apt-get update -y
RUN apt-get install -y \
              autoconf \
              automake \
              libtool \
              pkg-config \
              bison \
              flex \
              libcap-dev \
              libevtlog-dev \
              libglib2.0-dev \
              libhiredis-dev \
              libnet1-dev \
              libssl-dev \
              libwrap0-dev \
              uuid-dev \
              make \
              libevent-dev \
              git \
              curl \
              g++-multilib \
              lib32stdc++6 \
              libssl-dev \
              libncurses5-dev

RUN mkdir /sources
WORKDIR /sources
RUN git clone https://github.com/ihrwein/syslog-ng-rust-modules.git -b $ACTIONDB_RELEASE
RUN git clone https://github.com/ihrwein/syslog-ng.git -b $ACTIONDB_RELEASE
RUN git clone https://github.com/ihrwein/syslog-ng-incubator.git -b $ACTIONDB_RELEASE
RUN git clone https://github.com/ihrwein/actiondb.git -b $ACTIONDB_RELEASE

RUN curl -sL https://static.rust-lang.org/dist/rust-1.1.0-x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
RUN /tmp/rust-1.1.0-x86_64-unknown-linux-gnu/install.sh

WORKDIR /sources/syslog-ng
RUN ./autogen.sh && mkdir b && cd b && ../configure --with-python=no --prefix=$SYSLOG_NG_INSTALL_DIR && make && make install

WORKDIR /sources/syslog-ng-rust-modules
RUN cargo build
RUN echo "prefix=/sources/syslog-ng-rust-modules" > $PKG_CONFIG_PATH/libsyslog_ng_rust_modules.pc
RUN cat libsyslog_ng_rust_modules.pc | tail -n +2 >> $PKG_CONFIG_PATH/libsyslog_ng_rust_modules.pc

WORKDIR /sources/syslog-ng-incubator
RUN autoreconf -i
RUN mkdir b && cd b && ../configure --enable-rust && make && make install
ADD loggen.json $SYSLOG_NG_INSTALL_DIR/etc/
ADD syslog-ng.conf $SYSLOG_NG_INSTALL_DIR/etc/

WORKDIR /root/install/syslog-ng
EXPOSE 1514

CMD sbin/syslog -Fevd
