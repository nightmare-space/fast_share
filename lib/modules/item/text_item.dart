import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';

class TextMessageItem extends StatelessWidget {
  final TextMessage? info;
  final bool? sendByUser;

  const TextMessageItem({Key? key, this.info, this.sendByUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: sendByUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: sendByUser! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 260.w),
                    child: Column(
                      children: [
                        Theme(
                          data: ThemeData(
                            textSelectionTheme: const TextSelectionThemeData(
                              cursorColor: Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            info!.content!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
        if (!sendByUser!)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                showToast('内容已复制');
                await Clipboard.setData(ClipboardData(
                  text: info!.content ?? '',
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
