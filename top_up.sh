#!/bin/bash

if [ "$#" -lt 5 ]
then
	echo "Please specify Environment (prod|test), OperatorId, Amount, Country ISO Code and Recipient number"

	exit -1	
fi

ENV="$1"

if [ "test" = "$ENV" ]
then
	SANDBOX="-sandbox"
fi

TOKEN_FILE="token.$ENV"

if [ ! -f $TOKEN_FILE ] 
then
	>&2 echo "Token not found, fetching one"
	./get_token.sh $ENV > $TOKEN_FILE
fi

>&2 echo "Using token from $TOKEN_FILE"

OPERATOR_ID="$2"
AMOUNT="$3"
TOKEN=`cat $TOKEN_FILE`
COUNTRY_CODE="$4"
RECIPIENT_NUMBER="$5"

curl --location --request POST 'https://topups'$SANDBOX'.reloadly.com/topups' \
	--header 'Authorization: Bearer '$TOKEN \
	--header 'Accept: application/com.reloadly.topups-v1+json' \
	--header 'Content-Type: application/json' \
	--data-raw '{
		"operatorId":"'$OPERATOR_ID'",
		"amount":"'$AMOUNT'",
		"recipientPhone": {
			"countryCode": "'$COUNTRY_CODE'",
			"number": "'$RECIPIENT_NUMBER'"
		}
	}' | jq $6
