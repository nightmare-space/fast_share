import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/app/bindings/chat_binding.dart';
import 'package:speed_share/app/bindings/home_binding.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/main.dart';
import 'package:speed_share/pages/share_chat_window.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/document/document.dart';

part 'app_routes.dart';

class SpeedPages {
  SpeedPages._();
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => ThemeWidget(
        child: SpeedShareEntryPoint(),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () {
        if (GetPlatform.isWeb) {
          Uri uri = Uri.parse(url);
          return ThemeWidget(
            child: ShareChat(
              needCreateChatServer: false,
              chatServerAddress: 'http://${uri.host}:${Config.chatPort}',
            ),
          );
        }
        return ThemeWidget(
          child: ShareChat(
            needCreateChatServer:
                Get.parameters['needCreateChatServer'] == 'true',
            chatServerAddress: Get.parameters['chatServerAddress'],
          ),
        );
      },
      binding: ChatBinding(),
    ),
  ];
}

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeData theme =
        isDark ? DefaultThemeData.dark() : DefaultThemeData.light();
    return Theme(
      data: theme,
      child: child,
    );
  }
}
