#!/bin/bash


export AWS_SHARED_CREDENTIALS_FILE=/home/etl4tech_gmail_com/.aws/credentials
export AWS_CONFIG_FILE=/home/etl4tech_gmail_com/.aws/config

#IP_FILE="external_ip.txt"

HOSTED_ZONE_ID1="Z05398511B67RQISJXPBJ"
RECORD_NAME1="gce.pantload.net"
HOSTED_ZONE_ID2="Z02066441GJ2XWPVALM23"
RECORD_NAME2="ambiguousproductions.net"
LAST_IP_FILE="/tmp/last_ip"

current_ip=$(curl -s http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
if [ $? != 0 ] || [ -z "$current_ip" ]; then
	echo "Failed to get external IP"
	exit 2
fi

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

