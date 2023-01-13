#!/bin/bash

curl "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change" \
--request POST \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer 5uTr1qyvsb67AdySGxr0cImOhRfrjIwyMMAzTOngK4-Y8BSZ_0egqSqI0NrdgEc3iov699ZhMV-3s5zAzFGjQg" \
--data '
{
"short_desription": "Reboot server on scheduled interval",
"description":"This is the long description. Its reallllly long like.",
"assigned_to":"greg.hardy"
}' \
