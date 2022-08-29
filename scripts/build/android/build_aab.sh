LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../../..
source $PROJECT_DIR/scripts/properties.sh
flutter build appbundle --dart-define=VERSION=$VERSION --dart-define=OTHER_VAR=这是测试环境