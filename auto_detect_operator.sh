#!/bin/bash

if [ "$#" -ne 3 ]
then
	echo "Please specify Environment (prod|test) ISO Country Code and Recipient Number"

	exit -1	
fi

ENV="$1"

if [ "test" = "$ENV" ]
then
	SANDBOX="-sandbox"
fi

TOKEN_FILE="topups.token.$ENV"

if [ ! -f $TOKEN_FILE ] 
then
	echo "Token not found, fetching one"
	./get_token.sh $ENV topups > $TOKEN_FILE
fi

echo "Using token from $TOKEN_FILE"

COUNTRY_CODE="$2"
RECIPIENT="$3"
TOKEN=`cat $TOKEN_FILE`

curl --location --request GET 'https://topups'$SANDBOX'.reloadly.com/operators/auto-detect/phone/'$RECIPIENT'/countries/'$COUNTRY_CODE'?suggestedAmountsMap=true&SuggestedAmounts=true' \
	--header 'Authorization: Bearer '$TOKEN \
	--header 'Accept: application/com.reloadly.topups-v1+json' | jq $4
