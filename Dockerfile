#from nibirupool/nibiru:latest
FROM ubuntu:18.04

RUN  \
    apt update && apt -y upgrade && \
    apt install -y build-essential pkg-config libc6-dev m4 g++-multilib && \
    apt install -y autoconf libtool ncurses-dev unzip git python python-zmq && \
    apt install -y zlib1g-dev wget bsdmainutils automake curl libgconf-2-4 && \
    apt install -y vim
RUN \
    git clone https://github.com/snowgem/snowgem.git &&\
    cd snowgem &&\
    chmod +x zcutil/build.sh depends/config.guess depends/config.sub autogen.sh share/genbuild.sh src/leveldb/build_detect_platform depends/Makefile
RUN \
  cd snowgem &&\
  chmod +x zcutil/fetch-params.sh &&\
  ./zcutil/fetch-params.sh &&\
  mkdir /root/.snowgem
RUN \
    cd snowgem &&\
    ./zcutil/build.sh
#COPY ./blocknotify.c /var/
#RUN cd /var && gcc blocknotify.c -o blocknotify && mv /var/blocknotify /bin && rm /var/blocknotify.c
RUN \
  echo "#!/bin/bash\n/Snowgem/src/snowgemd && bash" > /root/entry.sh &&\
  chmod +x /root/entry.sh
VOLUME ["/root/.snowgem"]
ADD ./snowgem.conf /root/.snowgem/snowgem.conf
ENTRYPOINT ["/root/entry.sh"]
#ENTRYPOINT ["/bin/bash"]

