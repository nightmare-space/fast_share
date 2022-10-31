LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
PROJECT_DIR=$LOCAL_DIR/..
cp $LOCAL_DIR/main_personal.dartfile $PROJECT_DIR/lib/main_personal.dart
gsed -i "13a\  speed_share_extension:\n    path: ../speed_share_extension" pubspec.yaml
flutter pub get
flutter run --release -t lib/main_personal.dart
gsed -i "14,15d" pubspec.yaml
rm $PROJECT_DIR/lib/main_personal.dart

