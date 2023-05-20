# !/usr/bin/env sh
# 分abi打包脚本
# ./scripts/build/build_apk_split_abi.sh
LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../../..
source $PROJECT_DIR/scripts/properties.sh
flutter build ipa --dart-define=VERSION=$VERSION --dart-define=VERSION_CODE=$VERSION_CODE