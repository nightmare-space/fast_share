LOCAL_DIR=$(cd `dirname $0`; pwd)
flutter build macos
cp -rf "./build/macos/Build/Products/Release/Speed Share.app" /Applications/