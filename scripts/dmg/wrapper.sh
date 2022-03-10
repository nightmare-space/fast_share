LOCAL_DIR=$(cd `dirname $0`; pwd)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
appdmg $LOCAL_DIR/config.json "Speed Share.dmg"