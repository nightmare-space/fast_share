import 'package:file_manager/view/file_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/bindings/home_binding.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/modules/adaptive/adapive_entry.dart';
import 'package:speed_share/themes/theme.dart';

part 'app_routes.dart';

Debouncer debouncer = Debouncer(delay: const Duration(seconds: 1));
int time = 0;

class SpeedPages {
  SpeedPages._();
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/file',
      page: () => const ThemeWrapper(
        child: FileManagerPage(),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => Builder(builder: (context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (value) async {
            if (time == 0) {
              time++;
              showToast(S.current.backAgainTip);
            } else {
              Navigator.of(context).pop();
            }
            debouncer.call(() {
              time = 0;
            });
          },
          child: const ThemeWrapper(
            child: AdaptiveEntryPoint(),
          ),
        );
      }),
      binding: HomeBinding(),
    ),
  ];
}

class ThemeWrapper extends StatelessWidget {
  const ThemeWrapper({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeData theme = isDark ? dark() : light();
    return Theme(
      data: theme,
      child: child!,
    );
  }
}
