import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/themes/app_colors.dart';

import 'package:speed_share/themes/theme.dart';

class TextMessageItem extends StatelessWidget {
  final MessageTextInfo info;
  final bool sendByUser;

  const TextMessageItem({Key key, this.info, this.sendByUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              sendByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (info.sendFrom != null)
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffED796A).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Center(
                  child: Text(
                    info.sendFrom ?? '',
                    style: TextStyle(
                      height: 1,
                      fontSize: 12.w,
                      color: Color(0xffED796A),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 4.w,
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200.w),
                    child: Column(
                      children: [
                        Theme(
                          data: ThemeData(
                            textSelectionTheme: const TextSelectionThemeData(
                              cursorColor: Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            info.content,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 14.w,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!sendByUser)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                showToast('内容已复制');
                await Clipboard.setData(ClipboardData(
                  text: info.content,
                ));
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.content_copy,
                  size: 18.w,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
