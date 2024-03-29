#!/bin/bash

podman pod create --name=Vinculacion --share net -p 127.0.0.1:8890:8890 \
                  --add-host notebooks:127.0.0.1 --add-host Vinculacion_notebooks_1:127.0.0.1
podman run --rm --name=Vinculacion_notebooks_1 --pod=Vinculacion \
              -e LOCAL_USER_ID=1000 \
              --mount type=bind,source="$(realpath .)",destination=/proyecto \
              --mount type=bind,source="/home/javier/proy/tosogo/glue",destination=/glue \
              docker.io/jjclavijo/tosogo:latest jupyter-lab --allow-root --ip=0.0.0.0 --port=8890 --no-browser --notebook-dir=/proyecto/notebooks

podman pod rm Vinculacion
