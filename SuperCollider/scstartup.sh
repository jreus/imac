#!/bin/bash
FILEDIR=`pwd`;
FILEDIR+="/osctrl.test.scd";
echo "My FILEDIR is ${FILEDIR}";

while true
do

# SC Lang 3.4.4
cd /Applications/SuperCollider3.4.4;
./sclang "$FILEDIR";

sleep 1;

# Once sclang has quit/crashed - kill the server
# And loop
killall scsynth;

sleep 1;

done