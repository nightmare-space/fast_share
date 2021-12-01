LOCAL_DIR=$(cd `dirname $0`; pwd)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
# echo $PROJECT_DIR
if [ -f $PROJECT_DIR/$APP_NAME'_macOS.tar' ]; then
    rsync -v $PROJECT_DIR/$APP_NAME'_macOS.tar' $TARGET_PATH'/'$APP_NAME'_'$VERSION'_macOS'.tar
fi
if [ -f $PROJECT_DIR/$APP_NAME'_Windows.zip' ]; then
    target_name=$APP_NAME'_'$VERSION'_Windows.zip'
    echo "upload $target_name"
    rsync -v $PROJECT_DIR/$APP_NAME'_Windows.zip' $TARGET_PATH/$target_name
fi
rsync -v $PROJECT_DIR/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk $TARGET_PATH/$APP_NAME'_'$VERSION'_'Android_arm64.apk
rsync -v $PROJECT_DIR/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk $TARGET_PATH/$APP_NAME'_'$VERSION'_'Android_arm_v7a.apk
rsync -v $PROJECT_DIR/build/app/outputs/flutter-apk/app-x86_64-release.apk $TARGET_PATH/$APP_NAME'_'$VERSION'_'Android_x86_64.apk