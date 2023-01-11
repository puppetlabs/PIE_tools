#!/bin/bash

SYS_ID=$1

if [[ -z "${SYS_ID}" ]];then
  echo "usage: $0 [sys_id_change_record]"
  exit 2
fi 

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change/${SYS_ID}" \
--request GET \
--header "Accept: application/json" \
--user "greg.hardy":"gs1NUhQgIb7S"
