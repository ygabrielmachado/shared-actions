#!/bin/bash

app_name=$1
env=$2

if aws s3 sync --no-follow-symlinks artifact/ s3://${app_name}-${env}-bucket/; then
    echo "Deploy executado com sucesso."
    exit 0

else
    echo "Deploy falhou."
    exit 1
fi