#!/bin/bash


OAUTH_TOKEN=$1

usage(){
  echo "usage: $0 [oauth_token]"
}

if [[ -z "${OAUTH_TOKEN}" ]];then
  usage
  exit 2
fi 

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change" \
--request POST \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer ${OAUTH_TOKEN}" \
--data '
{
"short_description": "Reboot server on scheduled interval",
"description":"This is the long description. Its reallllly long like.",
"assigned_to":"greg.hardy",
}' \
