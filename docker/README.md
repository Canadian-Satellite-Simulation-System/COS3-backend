# NOS3 Desktop Container

Runs NOS3 inside an Ubuntu 24.04 container for hosts where the native scripts
don't work (e.g. macOS). The container runs its own Docker daemon
(Docker-in-Docker) for the containers NOS3 launches, and an XFCE desktop over
noVNC for gnome-terminal, 42, and the ground software GUIs.

## Start

```bash
./docker/run.sh
```

Then open http://localhost:6080/vnc.html and click Connect.

The repository is mounted at `/home/jstar/nos3`, so edits on the host show up
inside the container. The user is `jstar` with passwordless `sudo`.

## Build and run NOS3

In a terminal on the desktop:

```bash
cd ~/nos3
make config
make prep
make
make launch
```

`make stop` stops the simulation.

## Notes

- Give Docker Desktop at least 8 GB RAM and 4 CPUs (Settings > Resources).
- Pulled images and `~/.nos3` are kept in the `nos3-docker` and `nos3-home`
  volumes, so they survive container restarts. Remove them with
  `docker volume rm nos3-docker nos3-home`.
- Images without an arm64 build (e.g. `ballaerospace/cosmos:4.5.0`) run under
  emulation on Apple Silicon and will be slower.
- Stop the container with `docker rm -f nos3-desktop`.
