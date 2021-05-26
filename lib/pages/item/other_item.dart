import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/model/message_img_info.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:path/path.dart';

class OtherItem extends StatefulWidget {
  final MessageOtherInfo info;
  final bool sendByUser;

  const OtherItem({Key key, this.info, this.sendByUser}) : super(key: key);
  @override
  _OtherItemState createState() => _OtherItemState();
}

class _OtherItemState extends State<OtherItem> {
  MessageOtherInfo info;

  final Dio dio = Dio();

  double fileDownratio = 0.0;
  Future<void> downloadFile(String urlPath) async {
    print(urlPath);
    Response<String> response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    // final String _human = getFileSize(_fullByte); //拿到可读的文件大小返回给用户
    print('fullByte -> $fullByte');
    final String savePath = RuntimeEnvir.filesPath + '/' + basename(urlPath);
    // print(savePath);
    await dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (count, total) {
        final double process = count / total;
        Log.e(process);
        fileDownratio = process;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    info = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    String url = 'http://${info.address[2]}:8002/${info.url}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.info.title),
                SizedBox(
                  height: 4,
                ),
                if (!widget.sendByUser)
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation(
                        fileDownratio == 1.0 ? Colors.green : Colors.red,
                      ),
                      value: fileDownratio,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    print(url);
                    downloadFile(url);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.file_download,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
