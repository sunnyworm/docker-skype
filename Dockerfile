FROM sameersbn/ubuntu:14.04.20151213

RUN  echo "deb http://ftp.ubuntu-tw.org/mirror/ubuntu trusty main universe\n" > /etc/apt/sources.list \
  && echo "deb http://ftp.ubuntu-tw.org/mirror/ubuntu trusty-updates main universe\n" >> /etc/apt/sources.list
RUN apt-get update
ENV LANGUAGE zh_TW.UTF-8
ENV LANG zh_TW.UTF-8
ENV LC_ALL=zh_TW.UTF-8

RUN /usr/share/locales/install-language-pack zh_TW \
  && locale-gen zh_TW.UTF-8 \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get -qqy --no-install-recommends install language-pack-zh-hant

RUN apt-get -qqy --no-install-recommends install \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable

RUN apt-get -qqy install ttf-wqy-microhei \
  && ln /etc/fonts/conf.d/65-wqy-microhei.conf /etc/fonts/conf.d/69-language-selector-zh-tw.conf

ENV SKYPE_USER=skype

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7212620B \
 && echo "deb http://archive.canonical.com/ trusty partner" >> /etc/apt/sources.list \
 && dpkg --add-architecture i386 \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y pulseaudio:i386 skype:i386

COPY scripts/ /var/cache/skype/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
