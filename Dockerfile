FROM debian:12-slim

RUN printf "deb http://mirrors.ustc.edu.cn/debian bookworm main contrib non-free non-free-firmware\ndeb http://mirrors.ustc.edu.cn/debian bookworm-updates main contrib non-free non-free-firmware\n" > /etc/apt/sources.list
RUN apt update
RUN apt install -y ca-certificates mailcap curl jq

COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh  # Make the script executable

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

# VOLUME /srv
EXPOSE 80

COPY docker_config.json /.filebrowser.json
COPY filebrowser /filebrowser

ENTRYPOINT [ "/filebrowser" ]