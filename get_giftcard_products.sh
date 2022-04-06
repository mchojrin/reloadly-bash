#!/bin/bash

if [ "$#" -lt 1 ]
then
	echo "Please specify Environment (prod|test), optionally specify country ISO Code to filter"

	exit -1	
fi

ENV="$1"
if [ "test" = "$ENV" ]
then
	SANDBOX="-sandbox"
fi

URL='https://giftcards'$SANDBOX'.reloadly.com/products' 
if [ "$#" -ge 2 ]
then
	URL='https://giftcards'$SANDBOX'.reloadly.com/countries/'$2'/products' 
fi


TOKEN_FILE="giftcards.token.$ENV"

if [ ! -f $TOKEN_FILE ] 
then
	>&2 echo "Token not found, fetching one"
	./get_token.sh $ENV giftcards > $TOKEN_FILE
fi

>&2 echo "Using token from $TOKEN_FILE"
TOKEN=`cat $TOKEN_FILE`

curl --location --request GET $URL \
	--header 'Authorization: Bearer '$TOKEN \
	--header 'Accept: application/com.reloadly.giftcards-v1+json' \
	--header 'Content-Type: application/json'  
