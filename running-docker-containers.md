# Introduction
To train neural networks, we need to install a large amount of packages and software, including Rstudio, Keras, TensorFlow, etc. To make setup easier, we have pre-installed these packages and software in a **Docker container**. 

Containers are encapsulated virtual machines that can be run locally (i.e. on your laptop) or remotely (using cloud services or another machine such as UCSF's Wynton cluster).

Training neural nets is faster on machines with graphic processing units (GPUs), which most laptops don't have. Another advantage of Docker containers is that they allow you to easily switch between different machines without reinstalling packages everytime. 

We will be training neural networks in Docker containers **both locally on your laptop and in the cloud using GPU compute instances**; for the purpose of this class, we have obtained some free cloud services credits from [Neuromation](https://neu.ro). After this class, you may want to look into UCSF's Wynton cluster, GPU compute instances from Google Cloud or Amazon Web Services, etc.

### Glossary: 
- image -- a snapshot of a container that can be stored, transferred, reused. 
- [container](https://en.wikipedia.org/wiki/OS-level_virtualisation) -- a running instance of an image; an encaspulated computing environment

## Part 1: Training neural networks locally
### [SETUP before 5/23] Install Docker desktop software:
To be able to run Docker containers locally, you need to install Docker software on your computer.
Go to [Docker's website](https://www.docker.com/get-started), scroll down and click on the white-on-blue text on the right side 'Download Docker and Take a Tutorial', then follow the instructions to download Docker Desktop software. 

Note that Docker Desktop has minimum system requirements (e.g. it appears that for Mac, you should have OS 10.12 or above). We suggest first trying to install Docker Desktop for Mac/Windows. If it turns out that your machine does not fulfill the requirements, then follow [these instructions](https://docs.docker.com/v17.12/toolbox/overview/) to install Docker Toolbox, a legacy software, instead. 

### [SETUP before 5/23] Download a docker image to your local machine
Open up a command-line terminal window:
- If you installed Docker Desktop on Mac, open up the Terminal application ([see here for help](https://macpaw.com/how-to/use-terminal-on-mac) if you've never done this before).  
- If you installed Docker Desktop on Windows, open up a terminal window (Command Prompt or PowerShell, but not PowerShell ISE; [see here for help](https://www.youtube.com/watch?v=YdDngaoD1WE) if you've never done this before).
- If you installed Docker Toolbox on Mac/Windows, look for 'Docker Quickstart Terminal' in your Applications folder.

In order to run a container locally, you'll need to first download the image of the container from [Docker Hub](https://hub.docker.com/). Docker Hub has many interesting Docker images; we have also placed the Docker image we prepared for you there. Run the following command in your terminal window to download the image. It is quite large (~6Gb), so make sure you have enough disk space and you are on a fast internet connection before you run the command:

    docker pull dslituiev/tensorflow-rstudio:latest

### [SETUP before 5/23] Get your machine's IP address
In your terminal, type ifconfig (if Mac) or ipconfig (if Windows) to get your machine's IP address. It should be in a similar format to 192.168.99.100

### Run a docker container locally
In your terminal type:

    docker run -p 8787:8787 -it dslituiev/tensorflow-rstudio:latest

### Interact with docker container
In a browser window (e.g. Chrome, Safari), type:
    
    http://youripaddress/8787 

replacing youripaddress with your machine's IP address. You should now be able to work with RStudio in your browser in pretty much the same way you would work with the Rstudio software in your machine. In 5/23's structured discussion, we will go over how to train a neural network on your machine.

## Part 2: Training neural networks in the cloud
You have probably found that training neural networks locally on your laptop is very slow. Now we will try to train neural networks in the cloud using [Neuromation](https://neu.ro)'s GPU compute instances. To do so, we need to install a job scheduling client to send jobs to Neuromation's machines. 

### [SETUP before 5/30] Install conda Python 3.7
We will install Neuromation's job scheduling client in a conda virtual environment. Virtual environments serve a purpose similar to containers but are less resource consuming. Here, we use a virtual environment to prevent this installation from interfering with your existing Python installation. 

First, install conda on your machine. Download the Python 3.7 64-bit version from [here](https://docs.conda.io/en/latest/miniconda.html) then follow [these instructions for Mac](https://conda.io/projects/conda/en/latest/user-guide/install/windows.html) or [these instructions for Windows](https://conda.io/projects/conda/en/latest/user-guide/install/windows.html).

### [SETUP before 5/30] Setup virtual environment
Close your terminal window and open up a new one to allow the new Python installation to load. Create a new conda environment called 'neuromation' by typing the following into your terminal window:

        conda create --name neuromation python=3.7
        
Then activate the environment by typing the following into your terminal window:

        conda activate neuromation || source activate neuromation

### [SETUP before 5/30] Install Neuromation job scheduling client 
Now, install Neuromation's job scheduling client in that environment:

        pip install -U neuromation

### [SETUP before 5/30] Get Neuromation account 

To login to Neuromation, type the following in your terminal window:

    neuro login

which should open up a browser window pointing to Neuromation. Create an account and verify your email. After that, try logging in again by typing the same command in your terminal window:

    neuro login
    
This time, you should see a success message like 'logged into https://staging.neu.ro/api/v1'.

### Run a docker container in the cloud
Next, launch [the same Docker container as before](https://cloud.docker.com/repository/docker/dslituiev/tensorflow-rstudio/) by typing the following in your terminal window:

    neuro run dslituiev/tensorflow-rstudio:latest -c 4 -g 1 -m 16G --http 8787 
    
The flag -c 4 -g 1 -m 16G indicates that a Neuromation instance with 1 GPU, 4 CPUs, and 16G of memory are requested. The flag --http 8787 is the port number. 

Wait for the instance to start. After it is done, look for a line like that looks like https://job-000000-0000-0000.jobs-staging.neu.ro.

### Interact with docker container
In a browser window (e.g. Chrome, Safari), type in the URL:
    
    https://job-000000-0000-0000.jobs-staging.neu.ro

replacing 000000-0000-0000 with what you see in the line. When prompted for a login and password, use `rstudio` for both. In 5/30's structured discussion, we will go over how to train a neural network in the cloud.
