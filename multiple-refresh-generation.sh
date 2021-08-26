#!/bin/bash

if [ -z "$1" ];
then
    echo "Missing env path"
    echo " Usage: ./multiple-refresh-generation.sh env-path"
    echo " eg. ./refresh-and-generate.sh ./envs/"
    exit 1
else
    MRF_ENVS_PATH="$1"
fi

for MRF_FILE in "$MRF_ENVS_PATH"/*.env
do
    echo "Running script for ${MRF_FILE}"
    echo
    ./refresh-and-generate.sh "${MRF_FILE}"
    echo
done

echo $MRF_IDM
echo $RF_TOKEN
