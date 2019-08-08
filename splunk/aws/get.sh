#!/bin/bash

# Params
# 1: the aws resource .e.g  aws_vpc
# 2: the specific resource name .e.g grego-vpc
# 3: the key of the value you want extracted .e.g vpc_id

echo -n $(bundle exec puppet resource $1 $2 | grep $3 | cut -d\' -f2)
