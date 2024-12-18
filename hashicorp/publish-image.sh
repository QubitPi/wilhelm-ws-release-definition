#!/bin/bash
set -x
set -e

cd images
packer init .
packer validate .
packer build .
cd ../