# reloadly-bash

This project consists of a set of bash scripts that showcase how to use [Reloadly](https://reloadly.com)'s APIs.

The following services are available:

* [giftcards](https://docs.reloadly.com/giftcards/)
* [airtime](https://docs.reloadly.com/airtime/)
* [utility payment](https://docs.reloadly.com/utility-payments/)

# Installation

1. Clone this repository in a directory of your choice.
2. Copy the file `.env.example` to `.env.prod`
3. Fill [your credentials](https://www.reloadly.com/developers/api-settings) in the file `.env.prod`

# How to use

Running any script without any arguments will show a message with details on what is expected of you.

For instance, if you use `order_giftcard.sh` you'll get:

`Please specify Environment (prod|test), productId, quantity, unitPrice, senderName, recipientEmail`

The first argument is common for every script: the running environment (`prod` for production and `test` for [sandbox](https://docs.reloadly.com/devtools/toolbox/sandbox)), after that, each script has its own set of parameters.

# How it works

These scripts are simple wrappers to [cUrl](https://curl.se/) calls using the most common cases.

Since Reloadly uses [OAuth](https://en.wikipedia.org/wiki/OAuth) for authentication, the first task to be performed by each script is to get a valid token. To that end `get_token.sh` exists.

# Troubleshooting

If you get a message stating the token is invalid check for the existence of a file called `<product>.token.<environment>`, delete it and run the script again.
