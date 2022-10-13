import 'package:get/utils.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayHandler with TrayListener {
  TrayHandler() {
    if (!GetPlatform.isMobile) {
      initTray();
    }
  }

  Future<void> initTray() async {
    await trayManager.setIcon(
      'assets/icon/ic_launcher.png',
    );
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: 'Show Window',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'Exit App',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    // do something, for example pop up the menu
    windowManager.show();
    windowManager.setSkipTaskbar(false);
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    // do something
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      windowManager.show();
      windowManager.setSkipTaskbar(false);
      // do something
    } else if (menuItem.key == 'exit_app') {
      windowManager.destroy();
      // do something
    }
  }
}
