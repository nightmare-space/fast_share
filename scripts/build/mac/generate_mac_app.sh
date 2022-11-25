LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../../..
source $PROJECT_DIR/scripts/properties.sh
rm -rf "$PROJECT_DIR/scripts/dmg/Speed Share.dmg"
rm -rf "$PROJECT_DIR/scripts/dmg/Speed Share.app"
mv -f "$PROJECT_DIR/build/macos/Build/Products/Release/Speed Share.app" $PROJECT_DIR/scripts/dmg/
$PROJECT_DIR/scripts/dmg/wrapper.sh
# mv "$PROJECT_DIR/scripts/dmg/Speed Share.dmg" $PROJECT_DIR/
