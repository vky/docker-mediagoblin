## Description

Dockerizing [MediaGoblin](http://mediagoblin.org/) for easy use and deployment.

## Usage

** AUTOMATED BUILD IMAGE DOES NOT WORK **
** OBTAIN SOURCE CODE AND SEE GITHUB NOTES **

    sudo docker run -it --name="mediagoblin" -p 6543:6543 vky0/mediagoblin:latest

**NOTE**: If the running container is stopped, there will be no continuation of the previous session when starting a new container. It will be a completely fresh slate, including having to create a user again.

## Github Notes

Running `./build.sh` from within this repo's directory will build the Docker image, and `./run.sh` will run the image. The resulting container is run interactively; I couldn't get the email verification link from the docker logs when running with `-d`.

## TODO

* Setup Postgres as a separate linked container.
* Volume mount configuration file?
* Use [Fig](https://github.com/orchardup/fig/) make start up easier.
