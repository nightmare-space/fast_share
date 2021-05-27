import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/themes/theme.dart';

class TextMessageItem extends StatelessWidget {
  final String data;
  final bool sendByUser;

  const TextMessageItem({Key key, this.data, this.sendByUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.red,
                      selectionColor: Color(0xffede8f8),
                    ),
                  ),
                  child: SelectableText(
                    data,
                    cursorColor: Color(0xffede8f8),
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
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
