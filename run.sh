#!/bin/bash

set -eu

aws --output json --region us-east-1 --profile cloudformer cloudformation create-stack --stack-name oas-condor-estudiantes-redes --template-body file://./plantillas/redes.json | tee output.json
