import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/themes/app_colors.dart';

class TextMessageItem extends StatelessWidget {
  final String data;
  final bool sendByUser;

  const TextMessageItem({Key key, this.data, this.sendByUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color background = AppColors.surface;
    if (sendByUser) {
      background = AppColors.sendByUser;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.w),
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.red,
                      selectionColor: AppColors.accentColor,
                    ),
                  ),
                  child: SelectableText(
                    data,
                    cursorColor: AppColors.accentColor,
                    style: TextStyle(
                      color: AppColors.fontColor,
                      fontSize: 14.w,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!sendByUser)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                showToast('内容已复制');
                await Clipboard.setData(ClipboardData(
                  text: data,
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
