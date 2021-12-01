LOCAL_DIR=$(cd `dirname $0`; pwd)
flutter build macos
cp -rf ./build/macos/Build/Products/Release/速享.app /Applications/