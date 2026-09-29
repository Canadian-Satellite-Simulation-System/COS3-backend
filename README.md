# COS3 - Canadian Satellite Simulation System
TODO: Add more documentation :) 

## Docker Installation

COS3 runs inside an Ubuntu container with its own desktop, which you open in
your browser. This works on macOS (including Apple Silicon), Linux, and Windows
(through WSL2).

### Prerequisites

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and start it.
2. In Docker Desktop, open **Settings > Resources** and give it at least
   **8 GB of memory** and **4 CPUs**.
   builds are large.
3. On Windows, run all of the commands below in a WSL2 terminal (e.g. Ubuntu), not PowerShell.

### 1. Clone the repository with its submodules

```bash
git clone --recurse-submodules git@github.com:Canadian-Satellite-Simulation-System/COS3.git cos3
cd cos3
```

If you already cloned it without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
```

### 2. Start the container

```bash
./docker/run.sh
```

The first run builds the container image and takes a few minutes. When it
finishes, open **http://localhost:6080/vnc.html** and click **Connect**. You'll
see an Ubuntu desktop.

Your local copy of the repo is mounted in the container at `~/nos3`, so edits
you make on your computer show up inside the container right away.

### 3. Build and launch

Open a terminal on the container desktop (Applications > Terminal Emulator) and run:

```bash
cd ~/nos3
make config
make prep
make
make launch
```

After changing code, run `make` again, then `make launch`.

### Stopping the container
```bash
./docker/stop.sh
```

Downloaded images and build dependencies are kept in the Docker volumes
`cos3-docker` and `cos3-home`, so the next `./docker/run.sh` starts quickly. To
free the disk space completely:

```bash
docker volume rm cos3-docker cos3-home
```
