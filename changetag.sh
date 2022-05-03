#!/bin/bash
sed "s/tagVersion/$1/g" deploy/sampleapp-deploy-k8s.yml > deploy/sampleapp-deploy-k8.yml
