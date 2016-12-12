#!/bin/sh

# change working dir to location of script
cd "$(dirname "$0")"
# loaclhost
#MONGO_HOST="127.0.0.1"
#MONGO_PORT="27017"
#MONGO_DATABASE="opentmi_dev"

MONGO_HOST="ds119368.mlab.com"
MONGO_PORT="19368"
MONGO_DATABASE="heroku_mk02v12k"

# leave username and pw as empty strings if not needed
MONGO_DBUSERNAME="heroku_mk02v12k"
MONGO_DBPASSWORD="i50lrigs2ki7638kjdffnnaid9"

APP_NAME="inventory"
TIMESTAMP=`date +%Y-%m-%dT%H%M%S`
DEST=./${APP_NAME}_${TIMESTAMP}
mkdir $DEST

echo "Running mongodump with following settings:"
echo "hostaddress: $MONGO_HOST"
echo "port: $MONGO_PORT"
echo "db name: $MONGO_DATABASE"

if [[ -z "$MONGO_DBUSERNAME" || -z "$MONGO_DBPASSWORD" ]]; then
    mongodump --host $MONGO_HOST:$MONGO_PORT --db $MONGO_DATABASE --out $DEST
else
    echo "db username: $MONGO_DBUSERNAME"
    mongodump -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE -u $MONGO_DBUSERNAME -p $MONGO_DBPASSWORD -o $DEST
fi
