#!/bin/bash
#
# Starts the inner Docker daemon and an XFCE desktop served over noVNC.
#

set -e

VNC_RESOLUTION=${VNC_RESOLUTION:-1920x1080}

# cgroup v2 nesting (same approach as the official docker:dind image):
# move our processes out of the root cgroup so dockerd can enable controllers.
if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    mkdir -p /sys/fs/cgroup/init
    xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs 2>/dev/null || true
    sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
        > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
fi

echo "Starting Docker daemon..."
dockerd > /var/log/dockerd.log 2>&1 &
for i in $(seq 1 30); do
    docker info > /dev/null 2>&1 && break
    sleep 1
done
docker info > /dev/null 2>&1 || { echo "dockerd failed to start:"; tail -50 /var/log/dockerd.log; exit 1; }

# The NOS3 scripts use /tmp/nos3 for shared data
mkdir -p /tmp/nos3 && chown jstar:jstar /tmp/nos3
chown jstar:jstar /home/jstar/.nos3 2>/dev/null || true

echo "Starting desktop..."
sudo -u jstar -H bash -c "
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
    mkdir -p ~/.vnc
    printf '#!/bin/sh\nunset SESSION_MANAGER\nexec dbus-launch --exit-with-session startxfce4\n' > ~/.vnc/xstartup
    chmod +x ~/.vnc/xstartup
    vncserver :1 -geometry $VNC_RESOLUTION -depth 24 -SecurityTypes None -localhost yes -xstartup ~/.vnc/xstartup
"
websockify --web=/usr/share/novnc 6080 localhost:5901 > /var/log/novnc.log 2>&1 &

echo ""
echo "NOS3 desktop ready: http://localhost:6080/vnc.html"
echo ""

exec tail -f /var/log/dockerd.log
