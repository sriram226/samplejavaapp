#!/bin/bash
sed "s/tagVersion/$1/g" deploy-k8s.yml > deploy-k8.yml
