# Docker for ikiwiki

This is a Dockerfile for a sandbox ikiwiki.

## Run

The image is built on the Docker hub and you can pull & run:

    docker run -d -p 8001:80 --name ikiwiki elecnix/ikiwiki

Open http://localhost:8001/ and play with ikiwiki.
   
## Build yourself

You can build the image yourself with this git repository.

    docker build -t ikiwiki .

Run the built image:

    docker run -d -p 8001:80 --name ikiwiki ikiwiki

## Stop

    docker stop ikiwiki

