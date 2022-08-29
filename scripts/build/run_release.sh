LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../..
source $LOCAL_DIR/../properties.sh
flutter run --release --dart-define=VERSION=$VERSION --dart-define=OTHER_VAR=这是测试环境