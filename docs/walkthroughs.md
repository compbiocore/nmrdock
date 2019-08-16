# NMRdock Walkthrough

### Using NMRPipe to Process Bruker Data in NMRdock
1. Change the directory into your dataset. NMRdock is able to access your computer through `/home/ubuntu/data`. For the purposes of this tutorial, we are going to use the test data by typing into the command line:

	`cd /home/ubuntu/test/bruker2D`

2. Once we are in the folder with our data, type the command `bruker` and the bruker command window will open up.
![Bruker](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/brukerScreenShot.png)

3. Read in the parameters by pressing the **Read Parameters** button.
![Bruker Read Parameters](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/brukerScreenShotread.png)

4. Check to make sure that the parameters were read in correctly and update any values that need to be updated. Then press **Save Script** followed by **Execute Script** and the script will be executed to convert your Bruker formatted data into NMRPipe. You can then close the window and return to the command line.
![Bruker](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/brukerScreenShotfid.png)
5. To Fourier Transform the data, execute `./nmrproc.com` in the command line.
![nmrproc.com](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/brukerScreenShotnmrproc.png)
6. Now we can view the processed spectrum in NMRDraw by executing `nmrDraw`, which will open up the nmrDraw window (this can take a few seconds).
![Bruker](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/bruker2DnmrDraw.png)
7. If you are using your own data, you can phase and alter the `nmrproc.com` file yourself at this point. However, the `nmrproc.com` file for the included bruker data is already phased properly. Once the data is phased to your liking, you can close the NMRDraw window and return to the command line.
8. Congratulations! Your NMR spectrum is now processed. To convert the NMRPipe processed spectrum to the universal UCSF format, execute `pipe2ucsf test.ft2 bruker2D.ucsf`. You can then open the spectrum in sparky by executing `sparky bruker2D.ucsf`.

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

To run this image on Windows, a few steps must be taken to enable **X11** interfacing between the container and the host machine. 

1. This requires the installation of [VcXsrv Windows XServer](https://sourceforge.net/projects/vcxsrv/).

2. Install Docker for Windows [7/8/10 Home](https://docs.docker.com/toolbox/overview/) or [10 Pro/Educational/Enterprise](https://docs.docker.com/docker-for-windows/install/).

3. Open **XLaunch** by double clicking on the Desktop Icon.

4. A window will appear for you to set configurations. Use the default options on the first two pages by pressing the next button.
![XLaunch Page 1](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/XLaunch1.PNG)
![XLaunch Page 2](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/XLaunch2.PNG)

5. On the third page, select the box next "Disable access control" to ensure that the Docker has access to the XServer.
![XLaunch Page 3](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/XLaunch3.PNG)
![XLaunch Page 4](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/XLaunch4.PNG)

6. Get your IP address using ipconfig. This can be done in Command Line or Powershell
![IPCONFIG](https://github.com/compbiocore/nmrdock/raw/master/docs/assets/ipconfig2.PNG)

7. Open Docker and execute `docker run -it -v /c/:/home/ubuntu/data/ -e DISPLAY=x.x.x.x:0.0 compbiocore/nmrdock:latest /bin/bash`

where `x.x.x.x` is your IP address.

To use the development branch NMRdock, replace `latest` with `dev`.

### Linux

Most Linux distros have a native XServer that can be accessed by Docker. 

Install Docker for your distribution of [Linux](https://docs.docker.com/install/)

`docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v [path to a directory on local computer]:/home/ubuntu/data/ compbiocore/nmrdock:latest /bin/bash`

To use the development branch NMRdock, replace `latest` with `dev`.
