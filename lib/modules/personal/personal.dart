import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/modules/setting/setting_page.dart';
import 'package:speed_share/modules/widget/header.dart';
import 'package:speed_share/speed_share.dart';
import 'package:speed_share/themes/app_colors.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          const Header(),
          if (personHeader != null) personHeader,
          SizedBox(height: 12.w),
          personalItem(
            title: '关于速享',
            onTap: () {
              Get.to(const SettingPage());
            },
          ),
          personalItem(
            title: '服务条款',
            onTap: () {
              Get.to(const SettingPage());
            },
          ),
          personalItem(
            title: '隐私协议',
            onTap: () {
              Get.to(const SettingPage());
            },
          ),
          personalItem(
            title: '设置',
            onTap: () {
              Get.to(const SettingPage());
            },
          ),
        ],
      ),
    );
  }

  Widget personalItem({
    String title,
    void Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Material(
        borderRadius: BorderRadius.circular(12.w),
        color: AppColors.grey2,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.w),
          onTap: () {
            onTap();
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
