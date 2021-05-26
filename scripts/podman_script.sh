#!/bin/zsh

if { podman pod list | grep -q tosogo-vinculacion }
then 
  echo Reusando Pod tosogo-vinculacion
else 
  echo Creando Pod tosogo-vinculacion
  podman pod create --name=tosogo-vinculacion --share net -p 127.0.0.1:8890:8890
fi

MY_DIR=$(dirname "$0")

podrun () {
          podman run --rm --pod=tosogo-vinculacion  \
                     -e LOCAL_USER_ID=1000 \
                     --mount type=bind,source="$(realpath .)",destination=/proyecto \
                     --mount type=bind,source="/home/javier/proy/tosogo/glue",destination=/glue \
                     -w /proyecto\
                     docker.io/jjclavijo/tosogo:latest $@
          }

wkhtml () {

          cp $1 "$MY_DIR"/tmp.html

          sed '/<style/,/<\/style/ d' -i "$MY_DIR"/tmp.html

          sed 's/\/title>/\/title>\n/' -i "$MY_DIR"/tmp.html

          sed '/<title/ {a <link rel=\"stylesheet\" type=\"text\/css\" href=\"styles.css\" \/>
          }' -i "$MY_DIR"/tmp.html

          wkhtmltopdf --page-size 'A4' --enable-local-file-access --disable-smart-shrinking "$MY_DIR"/tmp.html $2

          rm "$MY_DIR"/tmp.html

          }

mkdir -p output

podrun papermill -f parametros.yaml notebooks/Vinculacion.ipynb output/Vectores.ipynb
podrun python -m nbconvert output/Vectores.ipynb --to html
wkhtml output/Vectores.html output/Vectores.pdf

podrun papermill -f parametros-poly.yaml notebooks/Poligonal.ipynb output/Poligonal.ipynb
podrun python -m nbconvert output/Poligonal.ipynb --to html
wkhtml output/Poligonal.html output/Poligonal.pdf

