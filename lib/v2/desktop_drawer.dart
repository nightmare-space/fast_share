import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

class DesktopDrawer extends StatefulWidget {
  const DesktopDrawer({Key key}) : super(key: key);

  @override
  State<DesktopDrawer> createState() => _DesktopDrawerState();
}

class _DesktopDrawerState extends State<DesktopDrawer> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DrawerItem(
              groupValue: index,
              value: 0,
              onChange: (v) {
                index = v;
                setState(() {});
              },
              child: Text('首页'),
            ),
            DrawerItem(
              groupValue: index,
              value: 1,
              onChange: (v) {
                index = v;
                setState(() {});
              },
              child: Text('全部设备'),
            ),
            DrawerItem(
              groupValue: index,
              value: 2,
              onChange: (v) {
                index = v;
                setState(() {});
              },
              child: Text('文件管理'),
            ),
            DrawerItem(
              groupValue: index,
              value: 3,
              onChange: (v) {
                index = v;
                setState(() {});
              },
              child: Text('设置'),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key key,
    this.groupValue,
    this.value,
    this.child,
    this.onChange,
  }) : super(key: key);
  final dynamic groupValue;
  final dynamic value;
  final Widget child;
  final void Function(int value) onChange;
  bool get enable => groupValue == value;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange?.call(value);
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 8.w,
        ),
        decoration: BoxDecoration(
          color:
              enable ? Theme.of(context).primaryColor.withOpacity(0.11) : null,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: enable ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
