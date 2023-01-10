#!/bin/bash

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change" \
--request POST \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data "{\"short_desription\": \"Reboot server on scheduled interval\" }" \
--user "greg.hardy":"gs1NUhQgIb7S"
