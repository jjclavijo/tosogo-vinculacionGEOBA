#!/bin/bash

MY_DIR=$(dirname "$0")

cp $1 "$MY_DIR"/tmp.html

sed '/<style/,/<\/style/ d' -i "$MY_DIR"/tmp.html

sed 's/\/title>/\/title>\n/' -i "$MY_DIR"/tmp.html

sed '/<title/ {a <link rel=\"stylesheet\" type=\"text\/css\" href=\"styles.css\" \/>
}' -i "$MY_DIR"/tmp.html

wkhtmltopdf --page-size 'A4' --enable-local-file-access --disable-smart-shrinking "$MY_DIR"/tmp.html $2

rm "$MY_DIR"/tmp.html
