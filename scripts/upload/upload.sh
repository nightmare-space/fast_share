LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
# echo $PROJECT_DIR
if [ -f "$PROJECT_DIR/dist/$APP_NAME.dmg" ]; then
    rsync -v "$PROJECT_DIR/dist/$APP_NAME.dmg" "${TARGET_PATH}/${APP_NAME_CN}_${VERSION}_macOS.dmg"
fi
if [ -f "$PROJECT_DIR/dist/$APP_NAME.deb" ]; then
    rsync -v "$PROJECT_DIR/dist/$APP_NAME.deb" "${TARGET_PATH}/${APP_NAME_CN}_${VERSION}_Linux.deb"
fi
if [ -f "$PROJECT_DIR/dist/${APP_NAME}_Windows.zip" ]; then
    target_name="${APP_NAME_CN}_${VERSION}_Windows.zip"
    rsync -v "$PROJECT_DIR/dist/${APP_NAME}_Windows.zip" "$TARGET_PATH/$target_name"
fi
arm64_apk="$PROJECT_DIR/dist/app-arm64-v8a-release.apk"
if [ -f "$arm64_apk" ]; then
    rsync -v "$arm64_apk" $TARGET_PATH/${APP_NAME_CN}_${VERSION}_Android_arm64.apk
fi
arm_apk="$PROJECT_DIR/dist/app-armeabi-v7a-release.apk"
if [ -f "$arm_apk" ]; then
    rsync -v "$arm_apk" $TARGET_PATH/${APP_NAME_CN}_${VERSION}_Android_arm_v7a.apk
fi
x86_apk="$PROJECT_DIR/dist/app-x86_64-release.apk"
if [ -f "$x86_apk" ]; then
    rsync -v "$x86_apk" $TARGET_PATH/${APP_NAME_CN}_${VERSION}_Android_x86_64.apk
fi
