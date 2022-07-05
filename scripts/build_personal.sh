gsed -i "75a\  speed_share_extension:\n    path: /Users/nightmare/Desktop/nightmare-space/speed_share_extension" pubspec.yaml
gsed -i "10aimport 'package:speed_share_extension/speed_share_extension.dart';" lib/main.dart
gsed -i "56a\   initPersonal();" lib/main.dart
flutter pub get
flutter run --release
gsed -i "76,77d" pubspec.yaml
gsed -i "11d" lib/main.dart
gsed -i "56d" lib/main.dart
