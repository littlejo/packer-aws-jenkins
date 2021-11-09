#!/bin/bash

packer build .
ami=$(cat packer-manifest.json | jq -r .builds[0].artifact_id | awk -F: '{print $2}')
echo "ami = \"$ami\"" > terraform/terraform.tfvars
