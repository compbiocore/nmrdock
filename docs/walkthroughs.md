# NMRdock Walkthrough

### Docker Installation

Docker engine for [Mac](https://docs.docker.com/docker-for-mac/install/), [Windows (Home)](https://docs.docker.com/toolbox/overview/),[Windows (Pro, Educational, Enterprise)](https://docs.docker.com/docker-for-windows/install/), and [Linux](https://docs.docker.com/v17.12/install/) must be downloaded and installed in order to run the Docker Image.

**NOTE:** Docker Desktop does **NOT** work on Windows 10 Home Edition. Windows 10 Home Edition requires Docker Toolbox.

### OSX

To run this image on OSX, a few steps must be taken to enable **X11** interfacing between the container and the host machine. This requires the installation of [XQuartz](https://www.xquartz.org/).

1. Install [Docker Desktop](https://docs.docker.com/docker-for-mac/install/)

2. Use [Homebrew](https://brew.sh/) or [MacPorts](https://www.macports.org/) to install **socat**:

	`brew install socat` or `sudo port install socat`
	
3. With **socat** installed, open a terminal window and type:

	`socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
	
4. Leave the **socat** window open and open a new tab in terminal.

5. Run the docker image by typing:

	`docker run -it -v [path to a directory on local computer]:/home/ubuntu/data/ -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=x.x.x.x:0 compbiocore/nmrdock:latest /bin/bash`

	where `x.x.x.x` is given by `ifconfig getifaddr en0` and `[path to a directory on local computer]` can be set to your \`pwd\` or the directory of your data. To use the development branch NMRdock, replace `latest` with `dev`.

This can be done with the following script command:
```
#!/bin/csh

open -a "Terminal"
osascript -e 'tell application "Terminal" to do script "socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\\\"$DISPLAY\\\""'
set A = `ipconfig getifaddr en0`
set C = ":0 compbiocore/nmrdock:latest /bin/bash"
set B = "docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/ubuntu/data/ -w /home/ubuntu/data/ -e DISPLAY=$A$C"

exec $B
```
### Windows

To run this image on Windows, a few steps must be taken to enable **X11** interfacing between the container and the host machine. This requires the installation of [VcXsrv Windows XServer](https://sourceforge.net/projects/vcxsrv/).

1. Install Docker for Windows [Home](https://docs.docker.com/toolbox/overview/) or [Pro/Educational/Enterprise](https://docs.docker.com/docker-for-windows/install/).

2. Open **XLaunch** by double clicking on the Desktop Icon.

3. A window will appear for you to set configurations. Use the default options on the first two pages by pressing the next button.

4. On the third page, select the box next "Disable access control" to ensure that the Docker has access to the XServer.

5. Get your IP address using ipconfig 

6. Open Docker and execute `docker run -it -v [path to a directory on local computer]:/home/ubuntu/data/ -e DISPLAY=x.x.x.x:0.0 compbiocore/nmrdock:latest /bin/bash`

where `x.x.x.x` is your IP address. To use the development branch NMRdock, replace `latest` with `dev`.

### Linux

Most Linux distros have a native XServer that can be accessed by Docker. 

Install Docker for your distribution of [Linux](https://docs.docker.com/install/)

`docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v [path to a directory on local computer]:/home/ubuntu/data/ compbiocore/nmrdock:latest /bin/bash`

To use the development branch NMRdock, replace `latest` with `dev`.
