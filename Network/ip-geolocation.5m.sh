#!/bin/bash
# <bitbar.title>ip-geolocation</bitbar.title>
# <bitbar.author>Sagar Chandarana</bitbar.author>
# <bitbar.author.github>sagar-chandarana</bitbar.author.github>
# <bitbar.desc>Shows the flag-emoji of the country where the external IP is located. Additionaly shows the city and region. Very helpful for people using VPN or proxies to manage their online presense.</bitbar.desc>

PATH=/usr/local/bin:$PATH
IP_DETAILS=`curl -s http://www.geoplugin.net/json.gp`

if [[ $IP_DETAILS == *"geoplugin_request"*"geoplugin_countryCode"* ]]; then
	EXTERNAL_IP=`echo "$IP_DETAILS" | jq -r '.geoplugin_request'`
else
	ERROR=IP_DETAILS
fi

if [ -n "$EXTERNAL_IP" ]; then 
	IP_COUNTRY=`echo "$IP_DETAILS" | jq -r '.geoplugin_countryCode'`
	IP_COUNTRY_NAME=`echo "$IP_DETAILS" | jq -r '.geoplugin_countryName'`
	CITY=`echo "$IP_DETAILS" | jq -r '.geoplugin_city'`
	REGION=`echo "$IP_DETAILS" | jq -r '.geoplugin_region'`
	FLAG_EMOJI=`curl -s https://gist.githubusercontent.com/sagar-chandarana/87a72755e736ebfb83c00a4d9113f4ac/raw/0b268dee002f33734c9e3bf13b4c4c66ea38e19d/countrycode-to-emojiflag.json | jq -r .$IP_COUNTRY.emoji`
fi

if [ "$1" = "copy" ]; then
  # Copy the IP to clipboard
  echo -n "$EXTERNAL_IP" | pbcopy
fi

if [ -z "$FLAG_EMOJI" ]; then
	FLAG_EMOJI="\xF0\x9F\x8D\x94"
fi

echo -e $FLAG_EMOJI
echo "---"

if [ -n "$EXTERNAL_IP" ]; then
	echo "$EXTERNAL_IP"
	echo "Copy IP | terminal=false bash=$0 param1=copy"
	if [ -n "$CITY" ]; then
		printf "$CITY, "
	fi

	if [ -n "$REGION" ]; then
		printf "$REGION, "
	echo $IP_COUNTRY_NAME
fi
else
	echo "Error:" $IP_DETAILS
fi

