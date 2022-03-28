#!/bin/bash

if [ "$#" -lt 6 ]
then
	echo "Please specify Environment (prod|test), productId, quantity, unitPrice, senderName, recipientEmail"

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
DATA='{
   "productId": '$2',
   "quantity": '$3',
   "unitPrice": '$4',
   "senderName": "'$5'",
   "recipientEmail": "'$6'"
}'

curl --location --request POST 'https://giftcards'$SANDBOX'.reloadly.com/orders' \
--header 'Authorization: Bearer '.$TOKEN \
--header 'Content-Type: application/json' \
--header 'Accept: application/com.reloadly.giftcards-v1+json' \
--data-raw "'"$DATA"'" | jq $7 
