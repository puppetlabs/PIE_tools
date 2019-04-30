# Puppet Enterprise Install tool for Development

## Intro

The master builder supports vmpooler and platform 9. It will launch and install a PE master based on the 
configuration in the config.env file.

## Configure the launcher

A simple configuration env file is included in the project. Examples are provided in the file.

## Create and Install in vmpoooler

Ensure that you have the pooler PEM file saved in ~/.ssh/id-rsa_acceptance

Next, double check you have read and completed the previous line.

./launch.sh

This will install and configure a vmpooler centos 7 node as a PE Master.

## Install PE on a centos node

If you just require PE to be installed. Copy the following script to your
preferred Centos based node.

./install_pe.sh


