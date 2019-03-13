One does not simply understand Docker
=====================================

Goal of this repository is to demonstrate main operational challenges of running server in general - and how exactly Docker can help with it. Intended audience is non-developers.  

# Basics

Regardless of what exactly you would like to run, any service requires following stack:  

**Hardware** (could be your laptop, could be in the cloud)  
**Operating System** (Windows, MacOS, Linux, you name it)  
**Server** (Node, JavaVM, plenty choices here)  
**Your application** (finally!)  

Note: Your application typically has specific requirements on server version or OS versions.  

# Development phase

## Run your first server

We are going to mimick work of developer on his local machine, to make sure the code does what it suppose to do.  

Our application is called `Little Server` and what it suppose to do is simply responding to your HTTP request you do from your browser with "Hello World" message.  

First you have to install [Node](https://nodejs.org/) on your local computer, because our application is written in language NodeJS.  

Once you have it, you can simply execute `node littleserver.js` and then you can open your browser and go to the address [http://localhost:1234](http://localhost:1234) and you should see your server running (responding with `Hello World` message in browser window).  
Congratulations! The development is done!  

## Run the server in target environment

Now try to deploy the application in "fake production". If you can, run EC2 in AWS or really any VM in any cloud (or use VirtualBox, as you wish) - or create an account [in Docker playground](https://labs.play-with-docker.com/) and start your first virtual instance "somewhere in the cloud".  

Now you have to install NodeJS again, copy over source code (file `littleserver.js`) and run `node littleserver.js` again.  

If you manage to do it, congratulations, now you deployed the code to production.  

Note: Developer's machine and production environment differs from production environment. You also might encounter different software versions, increasing risk of instability. Darn, if only there would be a way of encapsulation of our app, including OS, server and everything!

# Let's Dockerize!

Docker will help us to build *an image* of running server, *including operating system, server layer and our application*. Developer no longer delivers only plain source code of the app, but rather **working** container with *everything* the application needs.  

Container is merely isolated space, where everything runs independently on the local host. Only required software on host is the [Docker](https://www.docker.com/)!  

## Dockerfile

This file describes steps you need to do to run the application. You remember the steps from before? Installing NodeJS, copying over a file etc.? Have a look directly at `Dockerfile` and you will see all of our layers!  

`FROM` indicates base operating system, in this case we use Alpine Linux, because it's small and fast - good enough for our use case.  

`RUN` will install NodeJS with all necessary dependencies.  

`COPY` will take a source code of our application - `littleserver.js` and copy it into image with Alpine Linux and NodeJS installed.  

`EXPOSE` is just a information about our network port, necessary for our app to run.  

`CMD` is the command, which will be executed the moment we run our container.  

As you can see, steps we did manually before are now automated with Docker, we are not taking any shortcuts!  

Finally we have to build our image with command `docker build .`  
As a result, you should see response like: `Successfully built bcfba2a3217a` - that weird hash is actually name of our Docker image!  

But we can do better - `docker tag bcfba2a3217a somename/appname` will simply give this image nicer looking name, good for later reference!  

## Development run of Docker image

We need to test, if our application in Docker actually runs the way as before (as that's ultimately the goal): `docker run -p 1234:1234 somename/appname`. The `-p 1234:1234` says to Docker, which port to map to the host. After this command, go to [http://localhost:1234](http://localhost:1234) and you should see exactly the same result!  

Congratulations, your development is done!  

## Push Docker image

To make image deployable *anywhere else* we have to share it with some kind of image repository (each company has it's own private repository, usually, but some images are publicly available). We can then push the image from local machine to repository with command `docker push somename/appname` (login might be required).  

## Run the server in target environment

Assuming your target machine has Docker installed and assuming your target machine has access to image repository, you can now run the application exactly the same way, as before: `docker run -p 1234:1234 somename/appname`.  

And voila!

Note: As you can see, you don't have to worry about version of your operating system on host machine - because inside Docker we run Alpine Linux anyway. We don't have to care about any servers on the host - it's all inside a Docker container. We can now deploy *anywhere* and be sure results are *always* the same.  

And that's why we :love: Docker!