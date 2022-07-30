FROM ubuntu:20.04

RUN apt-get -y update \
	&& apt-get install -y software-properties-common \
	&& add-apt-repository multiverse \
	&& dpkg --add-architecture i386 \
	&& dpkg --configure -a \
	&& apt-get -y update \
	&& apt-get install -f \
	&& apt-get -y --fix-missing update
RUN	apt-get install --no-install-recommends -y gdb wget curl unzip zstd p7zip-full aria2 tilde libc6-i386 lib32z1
RUN apt-get install --no-install-recommends -y libncurses5:i386 libbz2-1.0:i386 libgcc1 lib32stdc++6 libtinfo5:i386
RUN apt-get install --no-install-recommends -y libcurl3-gnutls:i386 libsdl2-2.0-0:i386 libcurl4-gnutls-dev libcurl4-gnutls-dev:i386
RUN useradd -m -d /opt/tf2classic -s /usr/bin/bash steam
USER steam
RUN mkdir /opt/tf2classic/steamcmd
WORKDIR /opt/tf2classic/steamcmd
RUN curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar xvz --directory /opt/tf2classic/steamcmd/
ADD tf2classic.txt /opt/tf2classic/tf2classic.txt
RUN /opt/tf2classic/steamcmd/steamcmd.sh +runscript /opt/tf2classic/tf2classic.txt \
	&& cd /opt/tf2classic/ \
	&& aria2c --check-integrity=true --auto-file-renaming=false --continue=true --summary-interval=0 --bt-hash-check-seed=false --seed-time=0 https://wiki.tf2classic.com/misc/tf2classic-latest-zst.meta4
RUN	tar -I zstd -xvf /opt/tf2classic/tf2classic.tar.zst -C /opt/tf2classic/server/
RUN rm /opt/tf2classic/tf2classic.tar.zst && rm /opt/tf2classic/tf2classic-latest-zst.meta4
WORKDIR /opt/tf2classic/server/bin
USER root
RUN ln -s soundemittersystem_srv.so soundemittersystem.so && ln -s datacache_srv.so datacache.so && ln -s dedicated_srv.so dedicated.so && ln -s engine_srv.so engine.so && ln -s materialsystem_srv.so materialsystem.so && ln -s replay_srv.so replay.so && ln -s scenefilecache_srv.so scenefilecache.so && ln -s shaderapiempty_srv.so shaderapiempty.so && ln -s studiorender_srv.so studiorender.so && ln -s vphysics_srv.so vphysics.so
RUN mkdir /opt/tf2classic/.steam/sdk32 && ln -s /opt/tf2classic/steamcmd/linux32/steamclient.so /opt/tf2classic/.steam/sdk32/steamclient.so
RUN cd /opt/tf2classic/server/tf2classic/custom/ && rm -rf maps && rm -rf materials && rm -rf scripts && rm -rf sound
USER steam
WORKDIR /opt/tf2classic/server/
ADD cfg/* /opt/tf2classic/server/tf2classic/cfg/
ADD maps/* /opt/tf2classic/server/tf2classic/maps/
ADD custom/* /opt/tf2classic/server/tf2classic/custom/
USER root
RUN cd /opt/tf2classic/server/tf2classic/custom/ && rm -rf maps && rm -rf materials && rm -rf scripts && rm -rf sound
USER steam
ADD runserver.sh /opt/tf2classic/server/tf2classic
COPY --chown=steam addons /opt/tf2classic/server/tf2classic/addons
COPY --chown=steam sourcemod /opt/tf2classic/server/tf2classic/cfg/sourcemod

EXPOSE 27005/udp 27005/tcp 27015/udp 27015/tcp
#ENTRYPOINT ["/opt/tf2classic/server/tf2classic/srcds_run", "-autoupdate", "-steam_dir", "/home/steam/steamcmd", "-steamcmd_script", "/home/steam/steamcmd/tf2_ds.txt", "-game", "tf"]