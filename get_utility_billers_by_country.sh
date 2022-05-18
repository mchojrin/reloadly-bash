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

TOKEN_FILE="utilities.token.$ENV"

if [ ! -f $TOKEN_FILE ] 
then
	>&2 echo "Token not found, fetching one"
	./get_token.sh $ENV utilities > $TOKEN_FILE
fi

>&2 echo "Using token from $TOKEN_FILE"

COUNTRY_CODE="$2"
TOKEN=`cat $TOKEN_FILE`

curl --location --request GET 'https://utilities'$SANDBOX'.reloadly.com/billers?countryISOCode='$COUNTRY_CODE \
	--header 'Accept: application/com.reloadly.utilities-v1+json' \
	--header 'Authorization: Bearer '$TOKEN | jq $3
