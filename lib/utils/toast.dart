import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:speed_share/config/dimens.dart';

void showToast(
  String message, {
  Duration duration = const Duration(milliseconds: 1000),
}) {
  print(showToast);
  //创建一个OverlayEntry对象
  // final EdgeInsets padding = MediaQuery.of(toastContext).viewInsets;
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimens.gap_dp24,
                  0,
                  Dimens.gap_dp24,
                  Dimens.gap_dp24,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2.0,
                          sigmaY: 2.0,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                            // color: const Color(0xff2c2c2e),
                            color: Color(0xffececec).withOpacity(0.6),
                          ),
                          height: Dimens.gap_dp48,
                          // child:
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  //往Overlay中插入插入OverlayEntry
  Overlay.of(contexts.last).insert(overlayEntry);
  //两秒后，移除Toast
  Future<void>.delayed(duration).then((_) {
    // ExplosionWidget.bang();
    Future<void>.delayed(
        const Duration(
          milliseconds: 800,
        ), () {
      overlayEntry.remove();
    });
  });
}

List<BuildContext> contexts = [];

class NiToast extends StatefulWidget {
  const NiToast({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _NiToastState createState() => _NiToastState();
}

class _NiToastState extends State<NiToast> {
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            contexts.add(context);
            return widget.child;
          },
        ),
      ],
    );
  }
}
