# rigor_check_maker
 script to create rigor real browser checks

This script will leverates the Rigor API. To create a Real Browser Check, we are going to use: `POST /v2/checks/real_browsers`

THe API can be played with online via: 
https://monitoring-api.rigor.com/docs?url=%2Fv2%2Fdocs#!/Real_Browser_Checks/createRealBrowserCheck

## Prerequisites
You may need to install `jq` if you do not have it already installed in your shell. You can install via brew by running, for example `brew install jq`

## How to use
call create_check.sh to create a monitor or set of monitors (if you pass in a .txt file of \n delineated websites.)

for example `./create_check.sh --name "Nike Home Page Test" --site https://www.nike.com`

