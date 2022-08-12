#!/bin/bash

app_name=$1
env=$2

  if aws s3api head-bucket --bucket ${app_name}-${env}-bucket; then
	  aws s3 rm s3://${app_name}-${env}-bucket --recursive
  
  else
	  echo 'bucket does not exist'

fi