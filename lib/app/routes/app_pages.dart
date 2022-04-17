import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/bindings/chat_binding.dart';
import 'package:speed_share/app/bindings/home_binding.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/document/document.dart';
import 'package:speed_share/v2/home_page.dart';
import 'package:speed_share/v2/share_chat_window.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;

part 'app_routes.dart';

class SpeedPages {
  SpeedPages._();
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/file',
      page: () => const ThemeWrapper(
        child: fm.HomePage(),
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
            ? Uri.parse(kDebugMode ? 'http://192.168.184.102:12000/' : url)
            : Uri.parse(Get.parameters['chatServerAddress']);
        if (GetPlatform.isWeb) {
          return WebSpeedShareEntry(uri: uri);
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

class WebSpeedShareEntry extends StatefulWidget {
  const WebSpeedShareEntry({
    Key key,
    this.uri,
  }) : super(key: key);
  final Uri uri;

  @override
  State<WebSpeedShareEntry> createState() => _WebSpeedShareEntryState();
}

class _WebSpeedShareEntryState extends State<WebSpeedShareEntry> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            PageTransitionSwitcher(
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              duration: const Duration(milliseconds: 800),
              layoutBuilder: (widgets) {
                return Material(
                  color: Colors.white,
                  child: Stack(
                    children: widgets,
                  ),
                );
              },
              child: [
                ThemeWrapper(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ShareChatV2(
                      chatServerAddress:
                          'http://${widget.uri.host}:${widget.uri.port}',
                    ),
                  ),
                ),
                const ThemeWrapper(
                  child: fm.HomePage(),
                ),
              ][pageIndex],
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: NiIconButton(
            //       onTap: () {
            //         pageIndex == 0 ? pageIndex = 1 : pageIndex = 0;
            //         setState(() {});
            //       },
            //       child: const Icon(Icons.sync_alt_rounded),
            //     ),
            //   ),
            // ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Material(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              color: Colors.white,
              iconSize: 48.w,
              onPressed: () {
                pageIndex == 0 ? pageIndex = 1 : pageIndex = 0;
                setState(() {});
              },
              icon: Icon(
                Icons.sync_alt_rounded,
                size: 28.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
