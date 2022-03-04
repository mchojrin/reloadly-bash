#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Please provide environment (prod|test)"

	exit -1
fi

ENV="$1"
ENV_FILE=".env.$ENV"

if [ ! -f "$ENV_FILE" ]
then
	echo "Can't read $ENV_FILE"
	exit -2
fi

if [ "test" = "$ENV" ]
then
        SANDBOX="-sandbox"
fi

TOKEN_FILE="token.$ENV"

export $(cat $ENV_FILE | xargs)

curl --location --request POST 'https://auth.reloadly.com/oauth/token' \
	--header 'Content-Type: application/json' \
	--data-raw '{
		"client_id":"'$CLIENT_ID'",
		"client_secret":"'$CLIENT_SECRET'",
			"grant_type":"client_credentials",
				"audience":"https://topups'$SANDBOX'.reloadly.com"
			}' | jq -r ".access_token"
