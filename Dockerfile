FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal \
    tightvncserver \
    novnc \
    firefox-esr \
    sudo \
    dbus-x11 \
    && apt-get clean

RUN useradd -m -s /bin/bash kali && echo "kali:kali" | chpasswd && adduser kali sudo

USER kali
WORKDIR /home/kali

RUN mkdir -p /home/kali/.vnc && echo "12345678" | vncpasswd -f > /home/kali/.vnc/passwd && chmod 600 /home/kali/.vnc/passwd
RUN echo "#!/bin/bash\nxrdb \$HOME/.Xresources\nxsetroot -solid grey\nstartxfce4 &" > /home/kali/.vnc/xstartup && chmod +x /home/kali/.vnc/xstartup

USER root
EXPOSE 6080

CMD su kali -c "vncserver :1 -geometry 1280x800 -depth 24 -localhost no && /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080"
