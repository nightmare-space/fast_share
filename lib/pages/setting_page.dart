import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/themes/app_colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<String> addreses = [];
  String content = '';
  Widget addressItem(String uri) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(
          text: uri,
        ));
        content = uri;
        setState(() {});
        showToast('已复制到剪切板');
      },
      child: SizedBox(
        height: Dimens.gap_dp48,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.gap_dp12,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple,
                ),
                height: Dimens.gap_dp6,
                width: Dimens.gap_dp6,
              ),
              SizedBox(width: Dimens.gap_dp8),
              Text(
                uri,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  Future<void> getAddress() async {
    if (!GetPlatform.isWeb) {
      addreses = await PlatformUtil.localAddress();
      if (addreses.isNotEmpty) {
        content = 'http://${addreses.first}:${Config.shelfAllPort}';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: GetBuilder<SettingController>(builder: (ctl) {
        return Column(
          children: [
            SettingItem(
              title: '开启文件静态部署',
              subTitle: '开启后可通过本机IP地址+${Config.shelfAllPort}浏览文件',
              suffix: Switch(
                value: ctl.enableServer,
                onChanged: ctl.serverEnableChange,
              ),
            ),
            SettingItem(
              title: '静态网页部署端口',
              subTitle: '默认为${Config.shelfAllPort}',
            ),
            SettingItem(
              title: '聊天服务器端口',
              subTitle: '默认为${Config.chatPort}',
            ),
            SettingItem(
              title: 'IP过滤开关',
              subTitle: '默认将以10.开头的IP识别为移动数据的IP并进行过滤',
              suffix: Switch(
                value: ctl.enableFilter,
                onChanged: ctl.filterEnabledChange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: QrImage(
                data: content,
                version: QrVersions.auto,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '局域网的设备使用浏览器打开以下链接即可浏览本机文件，点击可复制链接和更新二维码',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Builder(builder: (_) {
                  List<Widget> list = [];
                  for (String address in addreses) {
                    // if (address.startsWith('10.')) {
                    //   // 10.开头的ip一般是移动数据获得的ip
                    //   continue;
                    // }
                    list.add(
                      addressItem('http://$address:${Config.shelfAllPort}'),
                    );
                  }
                  return Column(
                    children: list,
                  );
                }),
                // 关于软件
                // 其他版本下载
              ],
            ),
          ],
        );
      }),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({Key key, this.title, this.subTitle, this.suffix})
      : super(key: key);
  final String title;
  final String subTitle;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: Dimens.setWidth(68),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      color: AppColors.fontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimens.font_sp18,
                    ),
                  ),
                  Text(
                    '$subTitle',
                    style: TextStyle(
                      color: AppColors.fontColor.withOpacity(0.8),
                      // fontWeight: FontWeight.bold,
                      fontSize: Dimens.font_sp12,
                    ),
                  ),
                ],
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
      ),
    );
  }
}
