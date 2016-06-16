#!/bin/bash

set -eu

if ! aws --region us-east-1 --profile cloudformer cloudformation describe-stacks --stack-name oas-condor-estudiantes-redes
then
  aws --output json --region us-east-1 --profile cloudformer cloudformation create-stack --stack-name oas-condor-estudiantes-redes --template-body file://./plantillas/redes.json
else
  aws --output json --region us-east-1 --profile cloudformer cloudformation update-stack --stack-name oas-condor-estudiantes-redes --template-body file://./plantillas/redes.json
fi

finish_statuses=(CREATE_COMPLETE UPDATE_COMPLETE)
expected_statuses=(${finish_statuses[@]} UPDATE_IN_PROGRESS UPDATE_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_COMPLETE CREATE_IN_PROGRESS)

while true
do
  current_status="$(aws --output json --region us-east-1 --profile cloudformer cloudformation describe-stacks --stack-name oas-condor-estudiantes-redes | jq -r '.Stacks[]|.StackStatus')"
  valid_status="no"
  for expected_status in ${expected_statuses[@]}
  do
    if [ "${current_status}" == "${expected_status}" ]
    then
      valid_status="yes"
      break
    fi
  done
  if [ "${valid_status}" == "no" ]
  then
    echo "La creación o actualización del stack retornó un estado que no sabemos como tratar => '${current_status}'"
    exit 1
  fi
  exit_status="no"
  for finish_status in ${finish_statuses[@]}
  do
    if [ "${current_status}" == "${finish_status}" ]
    then
      exit_status="yes"
      break
    fi
  done
  if [ "${exit_status}" == "yes" ]
  then
    echo "Terminó la creación o actualización del stack => '${current_status}'"
    break
  fi
  echo "Estado del stack => '${current_status}'"
  sleep 2 # Para no sobrecargar la API
done
