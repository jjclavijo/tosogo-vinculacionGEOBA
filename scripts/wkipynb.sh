#!/bin/bash

python -m nbconvert $1 --to html tmp.html

sed '/<style/,/<\/style/ d' -i tmp.html

sed 's/\/title>/\/title>\n/' -i tmp.html

sed '/<title/ {a <link rel=\"stylesheet\" type=\"text\/css\" href=\"styles.css\" \/>
}' -i tmp.html


wkhtmltopdf --page-size 'A4' --enable-local-file-access --disable-smart-shrinking tmp.html $2

