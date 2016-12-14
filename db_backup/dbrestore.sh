#!/usr/bin/env bash

# Helper script that restores database collections from a db dump taken with mongodump (=dbdump.sh).
# USAGE
# local: $ ./dbrestore.sh local <pathOfDumpDirToRestore>
# remote: $ ./dbrestore.sh remote <pathOfDumpDirToRestore>
#
#https://docs.mongodb.com/v3.2/reference/program/mongorestore/


###########################################################
#      
#   MODIFY THESE TO YOUR LIKING:
#

# Used if arg = 'local'
LOCAL_MONGO_HOST="127.0.0.1"
LOCAL_MONGO_PORT="27017" # default mongoDB port
LOCAL_DB_NAME="opentmi_dev"

# Used if arg = 'remote'
REMOTE_MONGO_HOST="ds119368.mlab.com"
REMOTE_MONGO_PORT="19368"
REMOTE_DB_NAME="heroku_mk02v12k"
REMOTE_DB_USERNAME="heroku_mk02v12k"
REMOTE_DB_PASSWORD="i50lrigs2ki7638kjdffnnaid9"
#
#   DONT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING
#
#############################################################

function printHelp {
    echo "USAGE: ./dbrestore.sh ['local' | 'remote'] <pathOfDumpToRestore>"
    echo "'local' are 'remote' are aliases for host, port, dbname."
    echo "To change the values for local and remote, edit the variables in the script."
}

function printDumpInfo {
    echo "Running mongorestore with following settings:"
    echo "hostaddress: $MONGO_HOST"
    echo "port: $MONGO_PORT"
    echo "db name: $DB_NAME"
}

if [[ ( "$#" -ne 2 ) || ( "$1" -ne "local" ) || ( "$1" -ne "remote" ) ]]; then
    printHelp
    exit 1
fi
# change working dir to location of script
cd "$(dirname "$0")"
DB_DIR="$2"

if [ "$1" = "local" ] && [ -d "$2" ]; then
    MONGO_HOST="$LOCAL_MONGO_HOST"
    MONGO_PORT="$LOCAL_MONGO_PORT"
    DB_NAME="$LOCAL_DB_NAME"
    printDumpInfo
    mongorestore -h $MONGO_HOST:$MONGO_PORT -d $DB_NAME $DB_DIR --drop
elif [ "$1" = "remote" ] && [ -d "$2" ]; then
    MONGO_HOST="$REMOTE_MONGO_HOST"
    MONGO_PORT="$REMOTE_MONGO_PORT"
    DB_NAME="$REMOTE_DB_NAME" 
    printDumpInfo
    echo "db username: $REMOTE_DB_USERNAME"
    mongorestore -h $MONGO_HOST:$MONGO_PORT -d $DB_NAME -u $REMOTE_DB_USERNAME -p $REMOTE_DB_PASSWORD $DB_DIR --drop
else
    echo "Check input db path !!!"
    printHelp
fi