FROM ubuntu:16.04
LABEL maintainer "Andrew Leith <andrew_leith@brown.edu>"
LABEL repository compbiocore/nmrdock
LABEL image nmrdock
LABEL tag latest

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

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
    && apt-get -y install libgdk-pixbuf2.0-0:i386 libgtk2.0-0:i386 tcsh \
    # && apt-get -y install lib32ncurses5 lib32stdc++6 lib32z1 lib32gcc1 libxrender1:i386 libx11-6:i386 libxft2:i386 gtk2-engines:i386 gtk2-engines-*:i386 libcanberra-gtk-module:i386 libgtkmm-2.4*:i386 libatk-adaptor:i386 libgail-common:i386 \
    && apt-get -y install libqtcore4 libqtgui4 \
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

RUN conda install -y numpy scipy wxpython 

RUN cd home/ubuntu \
  && wget https://www.ibbr.umd.edu/nmrpipe/install.com \
  && wget https://www.ibbr.umd.edu/nmrpipe/binval.com \
  && wget https://www.ibbr.umd.edu/nmrpipe/NMRPipeX.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/s.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/dyn.tZ \
  && wget https://www.ibbr.umd.edu/nmrpipe/talos.tZ \
  && /bin/csh /home/ubuntu/install.com

RUN cd home/ubuntu \
  && wget https://s3.us-east-2.amazonaws.com/brown-docker-resources/nmrfam-sparky-linux64.tar.gz \
  && tar xvfz nmrfam-sparky-linux64.tar.gz \
  && cd nmrfam-sparky-linux64 \
  && sudo python ./install.py /usr/local/src \
  # && sudo cp /usr/lib32/libz.so.1 /usr/local/src/nmrfam-sparky-linux64/lib/libz.so \
  && touch /home/ubuntu/.cshrc
  # && echo 'setenv PATH ${PATH}:/usr/local/bin/nmrfam-sparky-linux64/bin' >> /home/ubuntu/.cshrc

RUN cd home/ubuntu \
  && wget https://sourceforge.net/projects/nmr-relax/files/4.1.1/relax-4.1.1.GNU-Linux.x86_64.tar.bz2 \
  && tar xjf relax-4.1.1.GNU-Linux.x86_64.tar.bz2 \
  && sudo ln -s /home/ubuntu/relax-4.1.1/relax /usr/local/bin \
  && wget https://downloads.sourceforge.net/project/minfx/1.0.12/minfx-1.0.12.zip \
  && unzip minfx-1.0.12.zip \
  && cd /home/ubuntu/minfx-1.0.12 \
  && pip install . \
  && cd /home/ubuntu/ \
  && wget https://downloads.sourceforge.net/project/bmrblib/1.0.4/bmrblib-1.0.4.zip \
  && unzip bmrblib-1.0.4.zip \
  && cd bmrblib-1.0.4 \
  && pip install .

RUN mkdir /home/ubuntu/data

RUN cd home/ubuntu \
  && mkdir nmr_wrappers \
  && cd nmr_wrappers \
  && wget https://raw.githubusercontent.com/compbiocore/nmr_image/master/nmr_wrappers/bruker \
  && wget https://raw.githubusercontent.com/compbiocore/nmr_image/master/nmr_wrappers/nmrDraw \
  && wget https://raw.githubusercontent.com/compbiocore/nmr_image/master/nmr_wrappers/sparky \
  && wget https://raw.githubusercontent.com/compbiocore/nmr_image/master/nmr_wrappers/varian \
  && chmod -R 755 /home/ubuntu/nmr_wrappers

ENV PATH /home/ubuntu/nmr_wrappers:$PATH

RUN sudo ln -s /home/ubuntu/nmrbin.linux /usr/local/bin/nmrbin.linux \
  && alias sparky="export SPARKYHOME='pwd';sparky" >> /home/ubuntu/.bashrc
