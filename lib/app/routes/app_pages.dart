import 'package:get/get.dart';
import 'package:speed_share/main.dart';
import 'package:speed_share/pages/share_chat.dart';
import 'package:speed_share/utils/document/document.dart';

part 'app_routes.dart';

class SpeedPages {
  SpeedPages._();
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => SpeedShare(),
    ),
    GetPage(
      name: Routes.chat,
      page: () {
        if (GetPlatform.isWeb) {
          Uri uri = Uri.parse(url);
          return ShareChat(
            needCreateChatServer: false,
            chatServerAddress: 'http://${uri.host}:${uri.port}',
          );
        }
        return ShareChat(
          needCreateChatServer:
              Get.parameters['needCreateChatServer'] == 'true',
          chatServerAddress: Get.parameters['chatServerAddress'],
        );
      },
    ),
  ];
}
