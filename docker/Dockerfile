# Ubuntu desktop container for running NOS3 on hosts where the native scripts
# don't work (e.g. macOS). Runs its own Docker daemon (Docker-in-Docker) so the
# NOS3 scripts can start their containers, and an XFCE desktop over noVNC so
# gnome-terminal, 42, and the ground software GUIs have a display.
#
# See docker/README.md for usage.

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        # Docker-in-Docker
        docker.io docker-compose-v2 iptables ca-certificates \
        # Desktop + VNC
        xfce4 xfce4-terminal dbus-x11 gnome-terminal tigervnc-standalone-server \
        tigervnc-tools novnc websockify x11-xserver-utils \
        # NOS3 host-side tooling
        git make python3 python3-pip sudo locales procps curl wget nano \
    && locale-gen en_US.UTF-8 \
    && apt-get purge -y xfce4-screensaver light-locker || true \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -m 0755 /etc/apt/keyrings \
    && wget -qO /etc/apt/keyrings/packages.mozilla.org.asc https://packages.mozilla.org/apt/repo-signing-key.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list \
    && printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' > /etc/apt/preferences.d/mozilla \
    && apt-get update && apt-get install -y --no-install-recommends firefox \
    && rm -rf /var/lib/apt/lists/*

# NOS3 user (uid 1000), in the docker group with passwordless sudo
RUN (userdel -r ubuntu || true) \
    && useradd -m -u 1000 -s /bin/bash -G docker,sudo jstar \
    && echo "jstar ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jstar

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 6080
VOLUME ["/var/lib/docker"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
