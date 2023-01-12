#!/bin/bash

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change" \
--request POST \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '
{
"short_desription": "Reboot server on scheduled interval",
"description":"This is the long description. Its reallllly long like.",
"assigned_to":"greg.hardy",
}' \
--user "greg.hardy":"gs1NUhQgIb7S"
