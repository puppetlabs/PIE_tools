# Puppet Enterprise Install tool for Development

## Intro

Blah blah

## Create and Install in vmpoooler

Ensure that you have the pooler PEM file saved in ~/.ssh/id-rsa_acceptance

Next, double check you have read and completed the previous line.

./create_master.sh

This will install and configure a vmpooler centos 7 node as a PE Master.

## Install PE on a centos node

If you just require PE to be installed. Copy the following script to your
preferred Centos based node.

./install_pe.sh


