import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'app/controller/controller.dart';
import 'app/routes/app_pages.dart';
import 'dynamic_island.dart';
import 'generated/l10n.dart';
import 'themes/theme.dart';

class SpeedShare extends StatelessWidget {
  const SpeedShare({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.initial;
    SettingController settingController = Get.find();
    return ToastApp(
      child: GetBuilder<SettingController>(builder: (context) {
        return GetMaterialApp(
          locale: settingController.currentLocale,
          title: '速享',
          initialRoute: initRoute,
          getPages: SpeedPages.routes,
          defaultTransition: Transition.fadeIn,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          builder: (context, child) {
            final bool isDark = Theme.of(context).brightness == Brightness.dark;
            final ThemeData theme = isDark ? DefaultThemeData.dark() : DefaultThemeData.light();
            return ResponsiveWrapper.builder(
              Builder(
                builder: (context) {
                  if (ResponsiveWrapper.of(context).isDesktop) {
                    ScreenAdapter.init(896);
                  } else {
                    ScreenAdapter.init(414);
                  }
                  return GetBuilder<SettingController>(
                    builder: (context) {
                      return Localizations(
                        locale: context.currentLocale,
                        delegates: const [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        child: Theme(
                          data: theme,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              child,
                              if (settingController.enbaleConstIsland) const DynamicIsland(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // maxWidth: 1200,
              minWidth: 480,
              defaultScale: false,
              breakpoints: const [
                ResponsiveBreakpoint.resize(300, name: MOBILE),
                ResponsiveBreakpoint.autoScale(600, name: TABLET),
                ResponsiveBreakpoint.resize(600, name: DESKTOP),
              ],
            );
          },
        );
      }),
    );
  }
}
