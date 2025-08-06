#!/bin/bash

#IP_FILE="external_ip.txt"

HOSTED_ZONE_ID1="Z05398511B67RQISJXPBJ"
RECORD_NAME1="pantload.net"
HOSTED_ZONE_ID2="Z02066441GJ2XWPVALM23"
RECORD_NAME2="ambiguousproductions.net"
LAST_IP_FILE="/tmp/last_ip"

current_ip=$(gcloud compute instances describe gce --zone=us-west1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
#current_ip=$(cat "$IP_FILE" 2>/dev/null)
last_ip=$(cat "$LAST_IP_FILE" 2>/dev/null)

if [ "$current_ip" != "$last_ip" ] && [ -n "$current_ip" ]; then
  # Update first record
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID1" \
    --change-batch "{
      \"Changes\": [{
        \"Action\": \"UPSERT\",
        \"ResourceRecordSet\": {
          \"Name\": \"$RECORD_NAME1\",
          \"Type\": \"A\",
          \"TTL\": 300,
          \"ResourceRecords\": [{\"Value\": \"$current_ip\"}]
        }
      }]
    }"
  
  # Update second record
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID2" \
    --change-batch "{
      \"Changes\": [{
        \"Action\": \"UPSERT\",
        \"ResourceRecordSet\": {
          \"Name\": \"$RECORD_NAME2\",
          \"Type\": \"A\",
          \"TTL\": 300,
          \"ResourceRecords\": [{\"Value\": \"$current_ip\"}]
        }
      }]
    }"
  
  echo "$current_ip" > "$LAST_IP_FILE"
  echo "Updated $RECORD_NAME1 and $RECORD_NAME2 to $current_ip"
fi
