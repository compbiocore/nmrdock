FROM ubuntu:16.04
LABEL maintainer "Andrew Leith <andrew_leith@brown.edu>"
LABEL repository compbiocore/nmr-image
LABEL image nmr-image
LABEL tag v1

RUN apt-get update -y \
    && apt-get -y install wget \
    && apt-get -y install sudo \
    && apt-get -y install git \
    && apt-get -y install screen \
    && wget https://s3.us-east-2.amazonaws.com/brown-cbc-amis/package_list.txt \
    && apt-get -y install $(grep -vE "^\s*#" package_list.txt  | tr "\n" " ") \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections \
    && apt-get -y install msttcorefonts \
    && dpkg --add-architecture i386 \ 
    && apt-get update -y \
    && apt-get -y install libc6:i386 libstdc++6:i386 libncurses5:i386 multiarch-support \
    && apt-get -y install xorg openbox \
    && apt-get -y install csh \
    && apt clean all

RUN useradd -m -d /home/ubuntu -s /bin/bash ubuntu \
    && echo "ubuntu ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu \
    && /bin/bash -c "source /home/ubuntu/.profile"

USER ubuntu
ENV HOME /home/ubuntu

RUN cd /home/ubuntu \
 && wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
 && bash Miniconda2-latest-Linux-x86_64.sh -b \
 && rm Miniconda2-latest-Linux-x86_64.sh

ENV PATH /home/ubuntu/miniconda2/bin:$PATH

RUN cd home/ubuntu \
  && wget https://www.ibbr.umd.edu/nmrpipe/install.com \
  && wget https://www.ibbr.umd.edu/nmrpipe/binval.com \
  && wget https://www.ibbr.umd.edu/nmrpipe/NMRPipeX.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/s.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/dyn.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/talos.tZ \
  && /bin/csh /home/ubuntu/install.com