#!/bin/bash
echo "killing stuff"

#kill messengar and reset server if they are running
fuser -k -n tcp 3100
fuser -k -n tcp 3000

#restart both
echo "restarting stuff"
cd fbap-messaging
npm run server &
cd ../fbap-application
npm run start &
