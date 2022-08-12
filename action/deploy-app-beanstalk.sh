#!/bin/bash

env=$1
region=$2
application=$3
cloud=$4

environment_name="${application}-${env}"
version_label="${application}-${env}-${GIT_COMMIT}-${BUILD_NUMBER}"
wait_interval=10

aws s3 cp artifact/app.zip s3://${application}-${env}-bucket/${env}/${version_label}

aws --region ${region} elasticbeanstalk create-application-version --application-name ${application} --version-label ${version_label} --source-bundle S3Bucket=${application}-${env}-bucket,S3Key=${env}/${version_label}
aws --region ${region} elasticbeanstalk update-environment --environment-name ${environment_name} --version-label ${version_label}

function check_environment() {
    aws elasticbeanstalk describe-environments --region ${region} --application-name ${application} --environment-names ${environment_name}
}

echo "Checando status do deploy no Beanstalk..."

environment_details=$(check_environment)

count=1
while  [ -z "${status}" ] || [ "${status}" == "Launching" ] || [ "${status}" == "Updating" ]; do

    sleep ${wait_interval}
    environment_details=$(check_environment)
    echo "Checando status do ambiente. Tentativa $count: $environment_details"
    status=$(echo "$environment_details" | jq -r '.Environments[0].Status')

    ((count++))

done

environment_details=$(check_environment)
version=$(echo "$environment_details" | jq -r '.Environments[0].VersionLabel')

if [ "$version" != "$version_label" ]; then
    echo "Deploy falhou. Ambiente ${environment_name} está executando uma versão diferente da aplicação ${version}."
    exit 1
else
    echo "Deploy executado com sucesso."
    exit 0
fi
