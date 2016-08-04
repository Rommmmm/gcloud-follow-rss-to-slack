#!/bin/bash

##This script takes the last <updated> value from google status rss feed and comapre it
##to previous one, if they are the same does nothing else there's an update in the feed
##sends it to slack

##This script should run on instance and not on local machine

#takes last <updated> value
curl -s "https://status.cloud.google.com/feed.atom" | grep "<updated>" | sed 's/.*<updated> \(.*\)/\1/' | head -2 | tail -1 | cut -d">" -f2 | cut -d"<" -f1 > /backups/cloud-monitoring/info/updated.txt

updated=$(cat /backups/cloud-monitoring/info/updated.txt)
updated2=$(cat /backups/cloud-monitoring/info/updated2.txt)

#if <updataed> value is equal to previous one do nothing
#else send msg with new incident details to slack
if [ $updated=$updated2 ];
then
echo 1

else 

msg=$(curl -s "https://status.cloud.google.com/feed.atom" | grep "<title>" | sed 's/.*<title> \(.*\)/\1/' | head -2 | tail -1 | cut -d">" -f2 | cut -d"<" -f1)
uri=$(curl -s "https://status.cloud.google.com/feed.atom" | grep "link href=" | sed 's/.*link href=" \(.*\)/\1/' | head -1 | cut -d"\"" -f2)
service=$(curl -s "$uri" | grep "<h1>" | sed 's/.*<h1>" \(.*\)/\1/' | head -2 | tail -1 | cut -d">" -f2 | cut -d" " -f1-3)

echo $msg on $service > /backups/cloud-monitoring/info/msg.txt

msg_to_slack=$(cat /backups/cloud-monitoring/info/msg.txt)
#echo $msg_to_slack

bash /backups/cloud-monitoring/info/slack2.sh "$msg_to_slack" "$uri"

cat /backups/cloud-monitoring/info/updated.txt > /backups/cloud-monitoring/info/updated2.txt

fi
