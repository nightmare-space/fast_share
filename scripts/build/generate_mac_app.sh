LOCAL_DIR=$(cd `dirname $0`; pwd)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
rm -rf $PROJECT_DIR/build/macos/Build/Products/Release/*
flutter build macos
rm -rf "$PROJECT_DIR/scripts/dmg/Speed Share.dmg"
rm -rf "$PROJECT_DIR/scripts/dmg/Speed Share.app"
cp -rf "$PROJECT_DIR/build/macos/Build/Products/Release/Speed Share.app" $PROJECT_DIR/scripts/dmg/
$PROJECT_DIR/scripts/dmg/wrapper.sh
# mv "$PROJECT_DIR/scripts/dmg/Speed Share.dmg" $PROJECT_DIR/