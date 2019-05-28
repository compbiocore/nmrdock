# NMRdock
NMR docker image dockerfile instructions


To run this image on OSX, a few steps must be taken to enable X11 interfacing between the container and the host machine.  The reason for these steps is that the Mac version of Docker is technically run inside of a VM, so that VM must be set to correctly forward ports.

First, run the following command:

  `ifconfig en0`

This command will yield a bunch of text.  One row will begin with:

  `inet x.x.x.x`  

Note that this is not the same as the row beginning with "inet6".  The x.x.x.x IP address should be copied, and ":0" should be appended to it, leaving you with:

  `x.x.x.x:0`

Next, you must download the software "socat" from Homebrew to enable the port forwarding.  To do so, type:

  `brew install socat`
  
With socat installed, open a terminal window and type:

  `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
  
Open another terminal tab without closing the socat tab, and then type:

`docker run -it -v [path to a directory on local computer]:/home/ubuntu/data/ -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=x.x.x.x:0 compbiocore/nmrdock:latest /bin/bash`

**Note: The latest version of NMRdock includes wrapper scripts for the various c-shell executibles.  It is therefore now possible (and, in fact, recommended) to interact with NMRdock using a bash shell.  The software will still be opened using c-shell.**  Any bugs created by this approach should be opened as Issues on github.

This command will open an interactive bash shell that forwards all GUI information to the local Xterm.

## Windows (not officially supported)

To run on Windows:

Download and install VcXsrv Windows X Server. You can download it from: https://sourceforge.net/projects/vcxsrv/

Before launching Docker, start XLaunch by double clicking the Desktop icon. A window will appear for you to set configurations. Use the default options on the first two pages and press the next button. On the third page select the box next to “Disable access control” to ensure the Docker has access to the Xserv.

Get your IP address using ipconfig.

Open Docker and execute `docker run -it -e DISPLAY=x.x.x.x:0.0 compbiocore/nmrdock:latest /bin/csh` where x.x.x.x is your IP address.
