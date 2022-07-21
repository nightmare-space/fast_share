# 编译web集成到assets
# ./scripts/build/build_web_add_web_assets.sh
LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/../..
rm -rf assets/web.zip
$LOCAL_DIR/build_web.sh
cd $PROJECT_DIR/build/web/
zip -r ../../assets/web.zip ./*
