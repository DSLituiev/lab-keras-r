
## Running docker containers
We will be using docker containers to run our jobs.
Containers are encapsulated virtual machines that can be run both locally and remotely.
When working with deep learning, it is useful to be able to run jobs on machines that have graphic processing units (GPUs), which are most laptops don't have.
Therefore, we will be using cloud services to run our containers on GPU compute instances.

Further we provide instructions for running containers both locally and in the cloud.

### Glossary: 
- [container](https://en.wikipedia.org/wiki/OS-level_virtualisation) -- encaspulated operating-system-level virtual compute environment
- image -- a snapshot of a container that can be stored and reused to provide reproducibility

### Running docker images locally
#### [SETUP] Sign up and download docker desktop software:
To be able to run docker containers locally, you need to install docker software on your computer.
Go to [Docker website](https://www.docker.com/get-started) and scroll down and click on a white-on-blue text on the right side 'Download Docker and Take a Tutorial'. Follow the instruction to download Docker software.

#### [SETUP] Download a docker image to your local machine

The image is quite large (~6Gb), so make sure you have enough disk space and you are on fast internet connection


#### Run a docker container locally
In your terminal type:

    docker run  -p 8787:8787 -it dslituiev/tensorflow-rstudio:latest

### Running docker images in the cloud
#### [SETUP] Install neuro platform client
 - Make sure conda is installed on your machine. Follow instructions [here](https://docs.conda.io/en/latest/miniconda.html). Use Python 3.7 64 bit version.
 - Open your terminal and run following commands to create a conda environment 
    
        conda create --name neuromation --python=3.7
        conda activate neuromation || source activate neuromation 

#### Run a docker container in the cloud

this will launch a GPU job using which uses [a docker image with rstudio, r-keras, and GPU-tensorflow](https://cloud.docker.com/repository/docker/dslituiev/tensorflow-rstudio/):

    neuro submit -c 4 -g 1 -m 16G --http 8787 dslituiev/tensorflow-rstudio:latest

+ Wait for the instance to start. After it is done, look for a line like:

> **Http URL**: https://job-000000-0000-0000.jobs-staging.neu.ro

+ open the link (on Mac, you do it by clicking on the link while holding Cmd key)
+ log in using `rstudio` for both login and password: _now you are in Rstudio environment!_

