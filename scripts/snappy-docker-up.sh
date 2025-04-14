# Steps to update (e.g.)
# sudo docker rm -f sonarr
# sudo docker rmi lscr.io/linuxserver/sonarr:latest
# run the command below again

docker run -d \
    --name homeassistant \
    --privileged \
    -e TZ=Europe/London  \
    -v /home/lathonez/HomeAssistant/config:/config  \
    -v /run/dbus:/run/dbus:ro \
    --network=host \
    --device /dev/ttyUSB0:/dev/ttyUSB0 \
    --restart=unless-stopped \
    ghcr.io/home-assistant/home-assistant:stable

docker run \
    -d \
    --name plex \
    --network=host \
    -e TZ="Europe/London" \
    -e PLEX_CLAIM="claim-xh1tyAfknWvgz8hc9f2J" \
    -v /home/lathonez/plex/config:/config \
    -v /tmp:/transcode \
    -v /media/lathonez:/data \
    --restart unless-stopped \
    plexinc/pms-docker

docker run -d \
    --name=nzbget \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Europe/London \
    -e NZBGET_USER=lathonez `#optional` \
    -e NZBGET_PASS=PassiveFoxWater `#optional` \
    -p 6789:6789 \
    -v /home/lathonez/nzbget/config:/config \
    -v /media/lathonez:/data \
    --restart unless-stopped \
    lscr.io/linuxserver/nzbget:latest

docker run -d \
    --name=sonarr \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Europe/London \
    -p 8989:8989 \
    -v /home/lathonez/sonarr/config:/config \
    -v /media/lathonez:/data `#optional` \
    --restart unless-stopped \
    lscr.io/linuxserver/sonarr:latest

docker run -d \
    --name=radarr \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Europe/LondonC \
    -p 7878:7878 \
    -v /home/lathonez/radarr/config:/config \
    -v /media/lathonez:/data `#optional` \
    --restart unless-stopped \
    lscr.io/linuxserver/radarr:latest

 docker run -d \
    --name=deluge \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Etc/UTC \
    -e DELUGE_LOGLEVEL=error `#optional` \
    -p 8112:8112 \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -p 58846:58846 `#optional` \
    -v /home/lathonez/deluge/config:/config \
    -v /media/lathonez:/data \
    --restart unless-stopped \
    lscr.io/linuxserver/deluge:latest

docker run -d \
    --name=motioneye \
    -e TZ=Etc/UTC \
    -e TZ=Europe/London \
    -p 8765:8765 \
    -p 8081:8081 \
    -p 8082:8082 \
    -p 8083:8083 \
    -p 8084:8084 \
    --hostname=motioneye \
    --restart unless-stopped \
    -v /home/lathonez/motioneye:/etc/motioneye \
    -v /home/lathonez/motioneye-recordings:/var/lib/motioneye \
    --detach=true \
    ccrisan/motioneye:master-amd64
