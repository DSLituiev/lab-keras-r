# Introduction
To train neural networks in R, we need to install a large amount of packages and software, including Keras, TensorFlow, Python, etc. To make setup easier, we have pre-installed these packages and software in a **Docker container**. 

Containers are encapsulated virtual machines that can be run locally (i.e. on your laptop) or remotely (using cloud services or another machine such as UCSF's Wynton cluster).

When working with deep learning, in order to speed up computation it is useful to run jobs on machines that have graphics processing units (GPUs), which most laptops don't have.

So, Docker containers also allow you to easily switch between running jobs locally and remotely without having to reinstall the packages and software needed everytime you switch machines.

Below we provide instructions to **run Docker containers both locally and in the cloud using GPU compute instances**.

### Glossary: 
- image -- a snapshot of a container that can be stored, transferred, reused. 
- [container](https://en.wikipedia.org/wiki/OS-level_virtualisation) -- a running instance of an image; an encaspulated computing environment

## Running docker images locally
### [SETUP] Sign up and download Docker desktop software:
To be able to run Docker containers locally, you need to install Docker software on your computer.
Go to [Docker website](https://www.docker.com/get-started) and scroll down and click on a white-on-blue text on the right side 'Download Docker and Take a Tutorial' then follow the instructions to download Docker Desktop software. 

Note that Docker Desktop has minimum system requirements (e.g. it appears that for Mac, you should have OS 10.12 or above). We suggest first trying to install Docker Desktop for Mac or Windows. If it turns out that your machine does not fulfill the requirements, then follow [these instructions]((https://docs.docker.com/v17.12/toolbox/overview/) to install Docker Toolbox, a legacy software, instead. 

### [SETUP] Download a docker image to your local machine
Open up a command-line terminal window:
- If you installed Docker Desktop on Mac, open up the Terminal application ([see here for help](https://macpaw.com/how-to/use-terminal-on-mac) if you've never done this before).  
- If you installed Docker Desktop on Windows, open up a terminal window (Command Prompt or PowerShell, but not PowerShell ISE; [see here for help](https://www.youtube.com/watch?v=YdDngaoD1WE) if you've never done this before).
- If you installed Docker Toolbox on Mac/Windows, look for 'Docker Quickstart Terminal' in your Applications folder.

In order to run a container locally, you'll need to first download the image of the container from dockerhub. Run the following command in your terminal window to download the Docker image we have prepared for you. It is quite large (~6Gb), so make sure you have enough disk space and you are on a fast internet connection before you run the command:

    docker pull dslituiev/tensorflow-rstudio:latest

### [SETUP] Get your machine's IP address
In your terminal, type ifconfig (if Mac) or ipconfig (if Windows) to get your machine's IP address. It should be in a similar format to 192.168.99.100

### Run a docker container locally
In your terminal type:

    docker run -p 8787:8787 -it dslituiev/tensorflow-rstudio:latest

### Interact with docker container
In a browser window (e.g. Chrome, Safari), type:
    
    http://youripaddress/8787 

replacing youripaddress with your machine's IP address. You should now be able to work with RStudio in your browser in pretty much the same way you would work with the Rstudio software in your machine. In this week's class, we will go over how to train a neural network in this docker container.

## Running docker images in the cloud
You will probably find running jobs locally in your laptop very slow. 
For the purpose of this class, we have obtained some free cloud services credits from Neuromation so that you can try running the container on a remote machine with more compute power and memory than your laptop. 
After this class, you may want to look into UCSF's Wynton cluster, GPU compute instances from Google Cloud or Amazon Web Services, etc.
To send jobs to Neuromation, we need to install a job scheduling client. 
The job scheduling client will allow us to run containers on a remote machine with more compute power and memory than your local machine.

### [SETUP] Install neuromation platform client
We'll be using conda virtual environment for our cloud job scheduling client.
Virtual environments serve a purpose similar to containers but are much much less resource consuming.
First, we will create an environment, then activate it, and finally, install our job scheduling client there

 - Make sure conda is installed on your machine. Follow instructions [here](https://docs.conda.io/en/latest/miniconda.html). Use Python 3.7 64-bit version.

 - Create a conda environment and install the client by pasting following commands into your terminal:

        conda create --name neuromation --python=3.7
        # first, activate your conda environment named 'neuromation'
        conda activate neuromation || source activate neuromation
        # install neuro client
        pip install -U neuromation

### Run a docker container in the cloud

Make sure you are logged into the neuro account:

    neuro login

We'll use [neu.ro](neu.ro) platform to launch [a docker image with rstudio, r-keras, and GPU-tensorflow](https://cloud.docker.com/repository/docker/dslituiev/tensorflow-rstudio/) on a 1-GPU instance with 4 CPUs.

    neuro run -c 4 -g 1 -m 16G --http 8787 dslituiev/tensorflow-rstudio:latest

+ Wait for the instance to start. After it is done, look for a line like:

> **Http URL**: https://job-000000-0000-0000.jobs-staging.neu.ro

+ open the link (on Mac, you do it by clicking on the link while holding Cmd key)
+ log in using `rstudio` for both login and password: _now you are in Rstudio environment!_

