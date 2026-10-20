#!/bin/bash -i
#
# Convenience script for NOS3 development
#

CFG_BUILD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_DIR=$CFG_BUILD_DIR/../../scripts
source $SCRIPT_DIR/env.sh
export GSW="openc3-openc3-operator-1"

# Debugging
#echo "Script directory = " $SCRIPT_DIR
#echo "Base directory   = " $BASE_DIR
#exit

#echo "Make /tmp folders..."
#mkdir /tmp/data 2> /dev/null
#mkdir /tmp/data/hk 2> /dev/null
#mkdir /tmp/uplink 2> /dev/null

echo "Prepare openc3 containers..."
cd $OPENC3_DIR
# Listen on all interfaces so COSMOS is reachable through the nos3-desktop
# container's port mapping (docker/run.sh still only exposes it to the host)
sed -i 's/"127.0.0.1:2900:2900"/"0.0.0.0:2900:2900"/' $OPENC3_DIR/compose.yaml
$OPENC3_PATH run
echo ""

echo "OpenC3 launch..."
pidof firefox > /dev/null
if [ $? -eq 1 ]
then
    firefox localhost:2900 &
fi
