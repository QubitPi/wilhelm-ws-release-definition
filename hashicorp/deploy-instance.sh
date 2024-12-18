#!/bin/bash
set -x
set -e

cd instances
terraform init
terraform validate
terraform apply -auto-approve
cd ../