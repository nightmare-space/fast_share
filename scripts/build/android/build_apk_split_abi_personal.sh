# !/usr/bin/env sh
# 分abi打包脚本
# ./scripts/build/build_apk_split_abi.sh
LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../../..
source $PROJECT_DIR/scripts/properties.sh
rm -rf $PROJECT_DIR/dist/*.apk
# flutter run --release --dart-define=VERSION=$VERSION -t lib/main_personal.dart --dart-define=VERSION_CODE=$VERSION_CODE
flutter build apk --dart-define=VERSION=$VERSION --dart-define=VERSION_CODE=$VERSION_CODE --tree-shake-icons --obfuscate --split-debug-info debug-info -t lib/main_personal.dart --split-per-abi
mkdir $PROJECT_DIR/dist/ 2>/dev/null
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk $PROJECT_DIR/dist/
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk $PROJECT_DIR/dist/
cp -f $PROJECT_DIR/build/app/outputs/flutter-apk/app-x86_64-release.apk $PROJECT_DIR/dist/
# ✓  Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (14.7MB).
# ✓  Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (15.1MB).
# ✓  Built build/app/outputs/flutter-apk/app-x86_64-release.apk (15.7MB).

# ✓  Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (13.9MB).
# ✓  Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (14.4MB).
# ✓  Built build/app/outputs/flutter-apk/app-x86_64-release.apk (15.0MB).