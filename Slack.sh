#!/bin/bash

url='SLACK-WEB-HOOK'
username='Cloud Monitoring'
to="#cloud_monitoring"
emoji=':sos:'

msg_to_slack=$1
incident=$2

message="$msg_to_slack, For more info <$incident|Click here> " 

payload="payload={\"channel\": \"${to}\", \"username\": \"${username}\", \"text\": \"${message}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data-urlencode "${payload}" $url

