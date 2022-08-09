# !/usr/bin/env sh
# 分abi打包脚本
# ./scripts/build/build_apk_split_abi.sh
flutter build apk --dart-define=APP_CHANNEL=www.baidu.com --dart-define=OTHER_VAR=这是测试环境 --split-per-abi
LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../..
mkdir $PROJECT_DIR/dist/ 2>/dev/null
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk $PROJECT_DIR/dist/
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk $PROJECT_DIR/dist/
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-x86_64-release.apk $PROJECT_DIR/dist/
