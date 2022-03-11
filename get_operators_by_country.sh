#!/bin/bash

if [ "$#" -lt 2 ]
then
	echo "Please specify Environment (prod|test) and ISO Country Code"

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
	>&2 echo "Token not found, fetching one"
	./get_token.sh $ENV topups > $TOKEN_FILE
fi

>&2 echo "Using token from $TOKEN_FILE"

COUNTRY_CODE="$2"
TOKEN=`cat $TOKEN_FILE`

curl --location --request GET 'https://topups'$SANDBOX'.reloadly.com/operators/countries/'$COUNTRY_CODE \
	--header 'Accept: application/com.reloadly.topups-v1+json' \
	--header 'Authorization: Bearer '$TOKEN | jq
