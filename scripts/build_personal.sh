gsed -i "76a\  speed_share_extension:\n    path: ../speed_share_extension" pubspec.yaml
gsed -i "10aimport 'package:speed_share_extension/speed_share_extension.dart';" lib/main.dart
gsed -i "64a\  initPersonal();" lib/main.dart
flutter pub get -v
flutter run --release
gsed -i "77,78d" pubspec.yaml
gsed -i "11d" lib/main.dart
gsed -i "64d" lib/main.dart
