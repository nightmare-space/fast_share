import 'dart:math';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/routes/page_route_builder.dart';

import 'send_file_bottom_sheet.dart';

class Nav extends StatefulWidget {
  const Nav({Key key, this.value, this.onTap}) : super(key: key);
  final int value;
  final void Function(int value) onTap;

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BottomTab(
          onChange: (value) {
            value = min(value, 1);
            widget.onTap?.call(value);
            setState(() {});
          },
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  size: 14.w,
                ),
                SizedBox(height: 2.w),
                Text(
                  '首页',
                  style: TextStyle(
                    fontSize: 12.w,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_copy,
                  size: 14.w,
                ),
                SizedBox(height: 2.w),
                Text(
                  '文件',
                  style: TextStyle(
                    fontSize: 12.w,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureWithScale(
          onTap: () {
            Navigator.of(context).push(CustomRoute(
              const SendFilePage(),
            ));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xff6A6DED),
                ),
                transformAlignment: Alignment.center,
                transform: Matrix4.identity()..rotateZ(pi / 4),
                width: 42.w,
                height: 42.w,
              ),
              Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomTab extends StatefulWidget {
  const BottomTab({Key key, this.children, this.onChange}) : super(key: key);
  final List<Widget> children;
  final void Function(int index) onChange;

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 58.w,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.children.length; i++)
              IconButton(
                padding: EdgeInsets.all(4.w),
                onPressed: () {
                  widget.onChange?.call(i);
                },
                icon: widget.children[i],
              ),
          ],
        ),
      ),
    );
  }
}
