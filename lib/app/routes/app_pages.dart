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
            ? Uri.parse(kDebugMode ? 'http://192.168.140.102:12000/' : url)
            : Uri.parse(Get.parameters['chatServerAddress']);
        return ThemeWrapper(
          child: WebSpeedShareEntry(
            address: 'http://${uri.host}:${uri.port}',
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
    this.address,
    this.fileAddress,
    this.padding,
  }) : super(key: key);
  final String address;
  final String fileAddress;
  final EdgeInsetsGeometry padding;

  @override
  State<WebSpeedShareEntry> createState() => _WebSpeedShareEntryState();
}

class _WebSpeedShareEntryState extends State<WebSpeedShareEntry> {
  ChatController chatController = Get.find();
  String get urlPrefix {
    Uri uri = Uri.tryParse(url);
    String perfix = 'http://${uri.host}:20000';
    if (kIsWeb && kDebugMode) {
      perfix = 'http://192.168.140.102:20000';
    }
    return perfix;
  }

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
                return Stack(
                  children: widgets,
                );
              },
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding:
                      widget.padding ?? EdgeInsets.symmetric(horizontal: 8.w),
                  child: ShareChatV2(
                    chatServerAddress: widget.address,
                  ),
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        // floatingActionButton:
        //     chatController.fileAddress.isNotEmpty || GetPlatform.isWeb
        //         ? Padding(
        //             padding: EdgeInsets.all(36.w),
        //             child: Material(
        //               color: Theme.of(context).primaryColor,
        //               borderRadius: BorderRadius.circular(40),
        //               clipBehavior: Clip.antiAlias,
        //               child: IconButton(
        //                 color: Colors.white,
        //                 iconSize: 48.w,
        //                 onPressed: () {
        //                   pageIndex == 0 ? pageIndex = 1 : pageIndex = 0;
        //                   setState(() {});
        //                 },
        //                 icon: Icon(
        //                   Icons.swap_horiz,
        //                   size: 28.w,
        //                 ),
        //               ),
        //             ),
        //           )
        //         : null,
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
