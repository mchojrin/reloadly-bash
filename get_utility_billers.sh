#!/bin/bash

if [ "$#" -lt 1 ]
then
	echo "Please specify Environment (prod|test)"

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

TOKEN=`cat $TOKEN_FILE`

curl --location --request GET 'https://utilities'$SANDBOX'.reloadly.com/billers' \
	--header 'Accept: application/com.reloadly.utilities-v1+json' \
	--header 'Authorization: Bearer '$TOKEN | jq $3
