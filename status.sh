#!/bin/bash
source .env
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" "https://api.digitalocean.com/v2/droplets?tag_name=$TAG" | jq
