#!/bin/bash

jq --indent 1 \
    '(.cells[] | select(has("outputs")) | .outputs) = []  
    | (.cells[] | select(has("execution_count")) | .execution_count) = null 
    | .metadata = {"language_info": {"name": "python", "pygments_lexer": "ipython3"},
                   "kernelspec": { "display_name": "Python 3", "language": "python",
                                   "name": "python3" }}
    | .cells[].metadata = {} 
    ' "$1" > tmp1.ipynb

jq --indent 1 \
    '(.cells[] | select(.source[] | contains("#CeldaDeParametros")) | .metadata) = {"tags":["parameters"]}
    ' tmp1.ipynb > "$1"

rm tmp1.ipynb
