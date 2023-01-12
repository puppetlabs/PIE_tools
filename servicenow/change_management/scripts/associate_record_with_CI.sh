#!/bin/bash

SYS_ID=$1

if [[ -z "${SYS_ID}" ]];then
  echo "usage: $0 [sys_id_change_record]"
  exit 2
fi

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change/${SYS_ID}/ci" \
--request POST \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '{cmdb_ci_sys_ids:'caf043a3b7fb23000999e4f6ee11a9c0,06f043a3b7fb23000999e4f6ee11a9c1', association_type:'affected'}' \
--user "greg.hardy":"gs1NUhQgIb7S"
