#!/bin/bash


KEYPATH=$PT_r10k_private_key
mv $KEYPATH /etc/puppetlabs/puppetserver/ssh/id-control_repo
chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-control_repo
echo puppetlabs | puppet access login --lifetime 5y --username admin
