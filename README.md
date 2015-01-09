# Docker for ikiwiki

This is a Dockerfile for a sandbox ikiwiki.

Build an image:

    docker build -t ikiwiki .

Run the built image:

    docker run -d -p 80:80 ikiwiki

Or simply pull from the Docker hub:

    docker pull elecnix/ikiwiki
   
