import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/modules/personal/setting/setting_page.dart';
import 'package:speed_share/modules/widget/header.dart';
import 'package:speed_share/speed_share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          if (personHeader != null)
            Column(
              children: [
                personHeader!,
                SizedBox(height: 8.w),
              ],
            ),
          SizedBox(height: 12.w),
          // personalItem(
          //   title: S.of(context).aboutSpeedShare,
          //   onTap: () {
          //     Get.to(const SettingPage());
          //   },
          // ),
          // personalItem(
          //   title: S.of(context).theTermsOfService,
          //   onTap: () {
          //     Get.to(const SettingPage());
          //   },
          // ),
          personalItem(
            title: S.current.projectBoard,
            onTap: () {
              Get.to(ScreenQuery(
                uiWidth: 600,
                screenWidth: Get.size.width,
                child: const ProjBoard(),
              ));
            },
          ),
          personalItem(
            title: S.of(context).privacyAgreement,
            onTap: () {
              Get.to(const PrivacyPage());
            },
          ),
          personalItem(
            title: S.of(context).setting,
            onTap: () {
              Get.to(const SettingPage());
            },
          ),
          personalItem(
            title: S.current.joinQQGroup,
            onTap: () async {
              const String url = 'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=673706601&card_type=group&source=qrcode';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              } else {
                showToast(S.current.openQQFail);
                // throw 'Could not launch $url';
              }
            },
          ),
          personalItem(
            title: S.current.changeLog,
            onTap: () async {
              Get.to(const ChangeLogPage());
            },
          ),
          personalItem(
            title: S.current.aboutSpeedShare,
            onTap: () async {
              String license = await rootBundle.loadString('LICENSE');
              Get.to(AboutPage(
                applicationName: S.current.appName,
                appVersion: Config.versionName,
                versionCode: Config.versionCode,
                logo: Padding(
                  padding: EdgeInsets.only(top: 32.w),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: Image.asset('assets/icon/app_icon_1024.png'),
                  ),
                ),
                otherVersionLink: 'http://nightmare.press/YanTool/resources/SpeedShare/?C=N;O=A',
                openSourceLink: 'https://github.com/nightmare-space/speed_share',
                license: license,
                canOpenDrawer: false,
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget personalItem({
    required String title,
    void Function()? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Material(
        borderRadius: BorderRadius.circular(12.w),
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.w),
          onTap: () {
            onTap!();
          },
          child: Container(
            height: 52.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.w),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
