# Deep Learning in R Lab

## Setup instructions

Please read the instructions in this document ([running-docker-containers.md](running-docker-containers.md)) and **complete any instructions marked as "[SETUP before 5/23]"** before the structured discussion on 5/23 so that we can spend most of class time training neural networks (instead of doing setup). If you are stuck on any part of the instructions, don't hesitate to post on the [CLE forum](https://courses.ucsf.edu/mod/forum/view.php?id=546441) -- if you are stuck, likely someone else in class is stuck too! 

UPDATE ON 5/24: Please **complete any instructions marked as "[SETUP before 5/30]"** before the structured discussion on 5/30. As before, don't hesitate to post on the CLE forum if you are stuck.

UPDATE ON 5/31: If you wish to continue training neural networks on your laptop after this class has ended, simply redo any instructions **not marked as SETUP**, i.e.:
- Load up the docker container using `docker run...` 
- Paste `http://localhost...` in your browser window and log into the Rstudio interface
- Download the R scripts again using `git clone...`
- Train your neural network! 
- Remember to stop the docker container when you are done, and periodically check `docker ps` to see if you forgot to stop any old docker containers. 

## Lab

We are going to learn how to train two neural networks to classify good old MNIST handwritten digits dataset. We will be using these R scripts:

- [mnist_elasticnet_logistic_regression.R](mnist_elasticnet_logistic_regression.R): Penalized logistic regression on MNIST

- [mnist_fc.R](mnist_fc.R): Fully-connected neural network on MNIST

- [mnist_conv.R](mnist_conv.R): Convolutional neural network on MNIST

