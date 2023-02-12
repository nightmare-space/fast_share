LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
# echo $PROJECT_DIR
linux_app="$PROJECT_DIR/dist/$APP_NAME.deb"
target_linux_app="$PROJECT_DIR/dist/${APP_NAME_CN}_${VERSION}_Linux.deb"
if [ -f $linux_app ]; then
    mv $linux_app $target_linux_app
    rsync -v $target_linux_app "${TARGET_PATH}/${APP_NAME_CN}_${VERSION}_Linux.deb"
fi
mac_app="$PROJECT_DIR/dist/${APP_NAME}_macOS.dmg"
target_mac_app="$PROJECT_DIR/dist/${APP_NAME_CN}_${VERSION}_macOS.dmg"
if [ -f $mac_app ]; then
    mv $mac_app $target_mac_app
    rsync -v $target_mac_app ${TARGET_PATH}/${APP_NAME_CN}_${VERSION}_macOS.dmg
fi
win_app="$PROJECT_DIR/dist/${APP_NAME}_Windows.zip"
target_name="${APP_NAME_CN}_${VERSION}_Windows.zip"
target_win_app="$PROJECT_DIR/dist/$target_name"
if [ -f $win_app ]; then
    mv $win_app $target_win_app
    echo "upload $target_name"
    rsync -v "$target_win_app" "$TARGET_PATH/$target_name"
fi
arm64_apk="$PROJECT_DIR/dist/app-arm64-v8a-release.apk"
target_arm64_apk="$PROJECT_DIR/dist/${APP_NAME_CN}_${VERSION}_Android_arm64.apk"
if [ -f "$arm64_apk" ]; then
    mv $arm64_apk $target_arm64_apk
    echo upload android arm64...
    rsync -v "$target_arm64_apk" "${TARGET_PATH}/${APP_NAME_CN}_${VERSION}_Android_arm64.apk"
fi
arm_apk="$PROJECT_DIR/dist/app-armeabi-v7a-release.apk"
target_arm_apk="$PROJECT_DIR/dist/${APP_NAME_CN}_${VERSION}_Android_arm_v7a.apk"
if [ -f "$arm_apk" ]; then
    mv $arm_apk $target_arm_apk
    echo upload android arm...
    rsync -v "$target_arm_apk" "$TARGET_PATH/${APP_NAME_CN}_${VERSION}_Android_arm_v7a.apk"
fi
x86_apk="$PROJECT_DIR/dist/app-x86_64-release.apk"
target_x86_apk="$PROJECT_DIR/dist/${APP_NAME_CN}_${VERSION}_Android_x86_64.apk"
if [ -f "$x86_apk" ]; then
    mv $x86_apk $target_x86_apk
    echo upload android x86...
    rsync -v "$target_x86_apk" "$TARGET_PATH/${APP_NAME_CN}_${VERSION}_Android_x86_64.apk"
fi
