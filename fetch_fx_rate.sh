#!/bin/bash

if [ "$#" -lt 3 ]
then
	echo "Please specify Environment (prod|test), operatorId and amount"

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

curl --location --request POST 'https://topups'$SANDBOX'.reloadly.com/operators/fx-rate' \
	--header 'Authorization: Bearer '$TOKEN \
	--header 'Accept: application/com.reloadly.topups-v1+json' \
	--header 'Content-Type: application/json' \
	--data-raw '{
	"operatorId":"'$OPERATOR_ID'",
		"amount":"'$AMOUNT'"
	}' | jq $4
