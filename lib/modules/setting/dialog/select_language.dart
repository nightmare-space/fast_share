import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/setting_controller.dart';

class SelectLang extends StatefulWidget {
  const SelectLang({Key? key}) : super(key: key);

  @override
  State<SelectLang> createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  SettingController controller = Get.find();
  String? groupValue = '';

  @override
  void initState() {
    super.initState();
    groupValue = controller.currentLocaleKey;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(12.w),
        child: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String lang in languageMap.keys.toList())
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lang),
                        Radio(
                          value: lang,
                          groupValue: groupValue,
                          onChanged: (dynamic value) {
                            groupValue = value;
                            controller.switchLanguage(value);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
