rm -rf ./tmp
PACKAGE_DIR=./tmp
target_dir=$PACKAGE_DIR/opt/speed-share
mkdir -p $target_dir
mkdir -p $PACKAGE_DIR/usr/share/applications
ICON_PATH=$PACKAGE_DIR/usr/share/pixmaps
mkdir -p $ICON_PATH
cp -rf ./build/linux/x64/release/bundle/. $target_dir
cp -rf ./res/linux/speed-share.png $ICON_PATH/
cp -rf ./res/linux/speed-share.desktop $PACKAGE_DIR/usr/share/applications/
mkdir $PACKAGE_DIR/DEBIAN
echo "
Package: speed-share
Architecture: amd64
Maintainer: @Nightmare
Version: 1.3.1-1
Homepage: https://nightmare.fun/speedshare/
Description: screen your phone on computer
">$PACKAGE_DIR/DEBIAN/control
dpkg-deb -b $PACKAGE_DIR "Speed Share.deb"