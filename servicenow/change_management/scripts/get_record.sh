#!/bin/bash

OAUTH_TOKEN=$1
SYS_ID=$2

usage(){
  echo "usage: $0 [oauth_token] [sys_id_change_record]"
}

if [[ -z "${OAUTH_TOKEN}" ]];then
  usage
  exit 2
fi 

if [[ -z "${SYS_ID}" ]];then
  usage
  exit 2
fi 

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change/${SYS_ID}" \
--request GET \
--header "Accept: application/json" \
--header "Authorization: Bearer ${OAUTH_TOKEN}" \

