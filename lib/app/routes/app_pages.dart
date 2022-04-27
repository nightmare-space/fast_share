import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/bindings/chat_binding.dart';
import 'package:speed_share/app/bindings/home_binding.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/document/document.dart';
import 'package:speed_share/v2/adapive_entry.dart';
import 'package:speed_share/v2/share_chat_window.dart';
import 'package:file_manager_view/file_manager_view.dart';

part 'app_routes.dart';

class SpeedPages {
  SpeedPages._();
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/file',
      page: () => const ThemeWrapper(
        child: FileManager(),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => ThemeWrapper(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: OverlayStyle.dark,
          child: const AdaptiveEntryPoint(),
        ),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () {
        Uri uri;
        uri = GetPlatform.isWeb
            ? Uri.parse(kDebugMode ? 'http://192.168.12.102:12000/' : url)
            : Uri.parse(Get.parameters['chatServerAddress']);

        if (GetPlatform.isWeb) {
          return ThemeWrapper(
            child: AdaptiveEntryPoint(
              address: 'http://${uri.host}:${uri.port}',
            ),
          );
        }
        return ThemeWrapper(
          child: ShareChatV2(
            chatServerAddress: 'http://${uri.host}:${uri.port}',
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
