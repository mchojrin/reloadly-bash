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

TOKEN_FILE="giftcards.token.$ENV"

if [ ! -f $TOKEN_FILE ] 
then
	>&2 echo "Token not found, fetching one"
	./get_token.sh $ENV giftcards > $TOKEN_FILE
fi

>&2 echo "Using token from $TOKEN_FILE"
TOKEN=`cat $TOKEN_FILE`

curl -v --location --request GET 'https://giftcards'$SANDBOX'.reloadly.com/products' \
	--header 'Authorization: Bearer '$TOKEN \
	--header 'Accept: application/com.reloadly.giftcards-v1+json' \
	--header 'Content-Type: application/json' | jq $2 
