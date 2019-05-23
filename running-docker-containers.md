# Running docker containers locally and in the cloud
## Introduction
To train neural networks, we need to install a several crucial packages and software, including Rstudio, Keras, TensorFlow, etc. To make setup easier, we have pre-installed these packages and software within a **Docker container**. 

Containers are encapsulated virtual machines that can be run locally (i.e. on your laptop) or remotely (using cloud services or another machine such as UCSF's Wynton cluster).

Training neural nets is faster on machines with graphic processing units (GPUs), which most laptops don't have. Another advantage of Docker containers is that they allow you to easily switch between different machines without reinstalling packages everytime. 

We will be training neural networks in Docker containers **both locally on your laptop and in the cloud using GPU compute instances**; for the purpose of this class, we have obtained some free cloud services credits from [Neuromation](https://neu.ro). After this class, you may want to look into UCSF's Wynton cluster, GPU compute instances from Google Cloud or Amazon Web Services, etc.

### Glossary: 
- image -- a snapshot of a container that can be stored, transferred, reused.
- [container](https://en.wikipedia.org/wiki/OS-level_virtualisation) -- a running instance of an image; an encaspulated computing environment.

- graphic processing unit (GPU) is a piece of hardware allowing for multiple computations of similar kind to be ran in parallel. Unlike CPU, it posesses one to several hundreds processing units that apply same instruction to multiple data at once. A typial single GPU unit is slower than a typical modern CPU unit, but multicore parallelization gives GPUs huge advantage in scientific computing tasks. 

- Keras -- a more user friendly interface to common deep learning frameworks, such as TensorFlow. Available as Python and R packages.

- [TensorFlow](https://en.wikipedia.org/wiki/TensorFlow) -- an open-source deep learning framework developed by Google.

- [PyTorch](https://en.wikipedia.org/wiki/PyTorch) -- an open source deep learning framework developed by Facebook (not used in this class). 

See [here](https://en.wikipedia.org/wiki/Comparison_of_deep-learning_software) if you're interested in learning about other deep learning software.

## Part 1: Training neural networks locally
### [SETUP before 5/23] Install Docker desktop software:
To be able to run Docker containers locally, you need to install Docker software on your laptop.
Go to [Docker's website](https://www.docker.com/get-started), scroll down and click on the white-on-blue text on the right side 'Download Docker and Take a Tutorial', then follow the instructions to download Docker Desktop software. 

Note that Docker Desktop has minimum system requirements (e.g. it appears that for Mac, you should have OS 10.12 or above). We suggest first trying to install Docker Desktop for Mac/Windows. If it turns out that your laptop does not fulfill the requirements, then follow [these instructions](https://docs.docker.com/v17.12/toolbox/overview/) to install Docker Toolbox, a legacy software, instead. 

Restart your laptop after installation.

### [SETUP before 5/23] Download a docker image to your laptop
Open up a command-line terminal window:
- If you installed Docker Desktop on Mac, open up the Terminal application ([see here for help](https://macpaw.com/how-to/use-terminal-on-mac) if you've never done this before).  
- If you installed Docker Desktop on Windows, open up a terminal window (Command Prompt or PowerShell, but not PowerShell ISE; [see here for help](https://www.youtube.com/watch?v=YdDngaoD1WE) if you've never done this before).
- If you installed Docker Toolbox on Mac/Windows, look for 'Docker Quickstart Terminal' in your Applications folder.

In order to run a container locally, you'll need to first download the image of the container from [Docker Hub](https://hub.docker.com/). Docker Hub has many interesting Docker images; we have also placed the Docker image we prepared for you there. Run the following command in your terminal window to download the image. It is quite large (~6Gb), so make sure you have enough disk space and you are on a fast internet connection before you run the command:

    docker pull dslituiev/tensorflow-rstudio:latest

### Run a docker container locally
In your terminal window, type this command:

    docker run -p 8787:8787 -it dslituiev/tensorflow-rstudio:latest

The terminal will become unresponsive and nothing will be printed out until you start doing something in Rstudio in your browser window (that will be opened up in the next step). Just proceed to the next step.

#### [Advanced alternative to previous step] Run a docker container locally with GPU support
If you happen to have an NVIDIA GPU and want to run your docker container on the GPU,  we provide info below on how you could do so. We will not do this option in class; this info is provided solely for your information.

First, install [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker). Then, enable GPU by including the `--runtime=nvidia` flag:

    docker run --runtime=nvidia -p 8787:8787 -it dslituiev/tensorflow-rstudio:latest

### Interact with Rstudio running within the docker container
In a browser window (e.g. Chrome, Safari), type this command:
    
    http://localhost:8787 

When on the login page, enter:

- login: `rstudio` 
- password:  `rstudio` 

You should then see an Rstudio interface that you can interact with much like how you would interact with Rstudio software. In 5/23's structured discussion, we will go over how to train a neural network on your laptop using this local setup.

### Stop docker container when done
When you are done, stop the docker container using these instructions:
- open up another terminal window and type `docker ps`
- get the hash sequence of the first container in the displayed list (some [hexadecimal](http://mathworld.wolfram.com/Hexadecimal.html) sequence like `d626dd302358`)
- run `docker stop [hash sequence]`
This will stop the command running in the previous terminal window and the Rstudio interface in the browser window.

## Part 2: Training neural networks in the cloud
You have probably found that training neural networks locally on your laptop is very slow. Now we will try to train neural networks in the cloud using [Neuromation](https://neu.ro)'s GPU compute instances. To do so, we need to install a job scheduling client to send jobs to Neuromation's machines. 

### [SETUP before 5/23] Get information about your Python installation
Type the following in a terminal window and make a note of what it returns (Python 2.x or Python 3.y). We will ask you about this in 5/23's structured discussion.
    
    python --version
    
### [SETUP before 5/30] Install conda Python 3.7
We will install Neuromation's job scheduling client in a conda virtual environment. Virtual environments serve a purpose similar to containers but are less resource consuming. Here, we use a virtual environment to prevent this installation from interfering with your laptop's existing Python installation. 

First, install conda on your laptop. Download the Python 3.7 64-bit version from [here](https://docs.conda.io/en/latest/miniconda.html) then follow [these instructions for Mac](https://conda.io/projects/conda/en/latest/user-guide/install/macos.html) or [these instructions for Windows](https://conda.io/projects/conda/en/latest/user-guide/install/windows.html).

### [SETUP before 5/30] Setup virtual environment
Close your terminal window and open up a new one to allow the new Python installation to load. Create a new conda environment called 'neuromation' by typing this command in your terminal window:

        conda create --name neuromation python=3.7
        
Then activate the environment by typing this:

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
Next, launch [the same Docker container as before](https://cloud.docker.com/repository/docker/dslituiev/tensorflow-rstudio/) by typing this command in your terminal window:

    neuro run dslituiev/tensorflow-rstudio:latest -c 4 -g 1 -m 16G --http 8787 
    
The flag `-c 4 -g 1 -m 16G` indicates that a Neuromation instance with 1 GPU, 4 CPUs, and 16G of memory are requested. The flag --http 8787 is the port number. 

Wait for the instance to start. After it is done, look for a line like that looks like https://job-000000-0000-0000.jobs-staging.neu.ro.

### Interact with Rstudio running within the docker container
In a browser window (e.g. Chrome, Safari), paste the URL that was returned at the previous step, _something similar to_:
    
    https://job-000000-0000-0000.jobs-staging.neu.ro

It will lead you to the rstudio log in page. If you see a neuromation logo, means your job is still loading. When on the login page, enter:

- login: `rstudio` 
- password:  `rstudio` 

You should then see an Rstudio interface that you can interact with much like how you would interact with Rstudio software on your laptop. In 5/30's structured discussion, we will go over how to train a neural network in the cloud using this. 
