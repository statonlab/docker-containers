## Docker Containers for Tripal
This repository offers 3 flavors of docker containers:
1. [drupal7](https://hub.docker.com/r/statonlab/drupal7/): Creates and installs a Drupal 7 site
1. [tripal3](https://hub.docker.com/r/statonlab/tripal3/): Builds on top of the Drupal 7 container to install Tripal 3 and prepares both Chado and Drupal to be used with Drupal.
1. tripal2: Under development

## Installation
To install, you can simply pull the containers from the docker hub or add a `FROM` line in your Dockerfile.
```bash
# Use one of the following to pull the container
docker pull statonlab/drupal7
docker pull statonlab/tripal3
docker pull statonlab/tripal2 # NOT AVAILABLE YET

# Or in your Docker file
FROM statonlab/drupal7:latest
FROM statonlab/tripal3:latest
FROM statonlab/tripal2:latest # NOT AVAILABLE YET
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
docker run -itd -p 80:8080 -p 5432:5432 --name my-container -v .:/modules/my-module statonlab:drupal7
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
