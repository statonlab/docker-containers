[![master Build Status](https://travis-ci.org/statonlab/docker-containers.svg?branch=master)](https://travis-ci.org/statonlab/docker-containers)

## Docker Containers for Tripal
This repository offers 3 flavors of docker containers:
1. [drupal7](https://hub.docker.com/r/statonlab/drupal7/): Creates and installs a Drupal 7 site
1. [tripal3](https://hub.docker.com/r/statonlab/tripal3/): Builds on top of the Drupal 7 container to install Tripal 3 and prepares both Chado and Drupal.
1. [tripal2](https://hub.docker.com/r/statonlab/tripal2/): Builds on top of the Drupal 7 container to install Tripal 2 and Chado 1.3.

## Installation
To install, you can simply pull the containers from the docker hub or add a `FROM` line in your Dockerfile.
```bash
# Use one of the following to pull the container
docker pull statonlab/drupal7
docker pull statonlab/tripal3
docker pull statonlab/tripal2

# Or in your Docker file
FROM statonlab/drupal7:latest
FROM statonlab/tripal3:latest
FROM statonlab/tripal2:latest
```

An image is available with the Tripal Devseed dataset pre-loaded! This was built using [v0.1.5 of this repo](https://github.com/statonlab/docker-containers/releases/tag/v0.1.5) and [v0.1.1 of the Devseed project](https://github.com/statonlab/tripal_dev_mini_dataset/releases/tag/v0.1.1).

```
docker pull statonlab/tripal3_seeded
```


### Usage

##### Ports
All containers expose the following ports:
- HTTP port 80
- PostgreSQL port 5432

##### Volumes
All containers install Drupal in `/var/www/html`. Therefore, mapping your custom modules should go in `/var/www/html/sites/all/modules/[your module folder name]`.
These containers also offer a shortcut to the modules directly in `/modules`, so instead of mapping modules to the Drupal path, you can simply map to `/modules/[module name]`.

#### Usage Examples
Run example:
```bash
# use -d to run in the background as shown below
docker run -itd -p 8080:80 -p 5432:5432 --name my-container -v .:/modules/my-module statonlab:drupal7
docker run -itd -p 8080:80 -p 5432:5432 --name my-container -v .:/modules/my-module statonlab:tripal3
docker run -itd -p 8080:80 -p 5432:5432 --name my-container -v .:/modules/my-module statonlab:drupal2
```
You can then visit `localhost:8080` to view your site.

Access a running container's shell and executing commands:
```bash
# NOTE: my-container is specified in the run command using the --name option.
# Access the shell
docker exec -it my-container bash

# Run drush
docker exec -it my-container drush en my-module
```

## Additional Information
The docker containers deploy a [supervisor](http://supervisord.org/) service that ensures apache and postgres get automatically restarted every time either fails. Thus, lowering the down time your site may experience.
