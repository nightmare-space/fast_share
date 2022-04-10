import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/app/bindings/chat_binding.dart';
import 'package:speed_share/app/bindings/home_binding.dart';
import 'package:speed_share/main.dart';
import 'package:speed_share/pages/share_chat_window.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/document/document.dart';
import 'package:speed_share/v2/home_page.dart';

part 'app_routes.dart';

class SpeedPages {
  SpeedPages._();
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => ThemeWrapper(
        child: AdaptiveEntryPoint(),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () {
        bool needCreateChatServer = GetPlatform.isWeb
            ? false
            : Get.parameters['needCreateChatServer'] == 'true';
        Uri uri;
        if (!needCreateChatServer) {
          uri = GetPlatform.isWeb
              ? Uri.parse(kDebugMode ? 'http://192.168.253.152:12000/' : url)
              : Uri.parse(Get.parameters['chatServerAddress']);
        }
        return ThemeWrapper(
          child: ShareChat(
            needCreateChatServer: needCreateChatServer,
            chatServerAddress:
                needCreateChatServer ? null : 'http://${uri.host}:${uri.port}',
          ),
        );
      },
      binding: ChatBinding(),
    ),
  ];
}

class ThemeWrapper extends StatelessWidget {
  const ThemeWrapper({
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
