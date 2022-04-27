import 'dart:io';

import 'package:animations/animations.dart';
import 'package:app_manager/app_manager.dart';
import 'package:app_manager/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;

import 'header.dart';
import 'icon.dart';

class NiIconButton extends StatelessWidget {
  const NiIconButton({Key key, this.child, this.onTap}) : super(key: key);
  final Widget child;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.w),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: child,
        ),
      ),
    );
  }
}

class FilePage extends StatefulWidget {
  const FilePage({Key key}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                const Header(),
                Padding(
                  padding: EdgeInsets.only(right: 48.w),
                  child: NiIconButton(
                    onTap: () {
                      pageIndex == 0 ? pageIndex = 1 : pageIndex = 0;
                      setState(() {});
                    },
                    child: const Icon(Icons.swap_horiz),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.w),
            Expanded(
              child: PageTransitionSwitcher(
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
                duration: const Duration(milliseconds: 600),
                layoutBuilder: (widgets) {
                  return Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: widgets,
                    ),
                  );
                },
                child: [
                  fileList(context),
                  fm.FileManager(
                    drawer: false,
                    path: '/sdcard/SpeedShare',
                    address: 'http://127.0.0.1:20000',
                    padding: EdgeInsets.only(bottom: 8.w),
                    usePackage: true,
                  ),
                ][pageIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getWidth(double max) {
    return (max - 36.w) / 4;
  }

  Material fileList(BuildContext context) {
    if (ResponsiveWrapper.of(context).isDesktop) {
      return Material(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            LayoutBuilder(builder: (context, con) {
              double width = getWidth(con.maxWidth);
              return Wrap(
                runSpacing: 12.w,
                spacing: 12.w,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    child: dir(context),
                  ),
                  SizedBox(
                    width: width,
                    child: onknownFile(context),
                  ),
                  SizedBox(
                    width: width,
                    child: zipFile(context),
                  ),
                  SizedBox(
                    width: width,
                    child: docFile(context),
                  ),
                  SizedBox(
                    width: width,
                    child: audio(context),
                  ),
                  SizedBox(
                    width: width,
                    child: video(context),
                  ),
                  SizedBox(
                    width: width,
                    child: imgFile(context),
                  ),
                  SizedBox(
                    width: width,
                    child: imgFile(context),
                  ),
                ],
              );
            }),
          ],
        ),
      );
    }
    return Material(
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.w),
            dir(context),
            SizedBox(height: 12.w),
            onknownFile(context),
            SizedBox(height: 12.w),
            Row(
              children: [
                Expanded(child: zipFile(context)),
                SizedBox(width: 12.w),
                Expanded(child: docFile(context)),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(child: audio(context)),
                SizedBox(width: 10.w),
                Expanded(child: video(context)),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(child: imgFile(context)),
                SizedBox(width: 10.w),
                Expanded(child: apkFile(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CardWrapper video(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('视频'),
          SizedBox(
            height: 4.w,
          ),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(
            height: 4.w,
          ),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity name in ctl.videoFiles) {
                  children.add(
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(name.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(name.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 8.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CardWrapper audio(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('音乐'),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 10.w),
          GetBuilder<FileController>(
            builder: (ctl) {
              List<Widget> children = [];
              for (FileSystemEntity file in ctl.audioFiles) {
                children.add(
                  Column(
                    children: [
                      getIconByExt(file.path),
                      SizedBox(
                        height: 4.w,
                      ),
                      Text(
                        path.basename(file.path),
                        style: TextStyle(
                          fontSize: 10.w,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
                children.add(
                  SizedBox(
                    width: 20.w,
                  ),
                );
              }
              if (children.isEmpty) {
                return Center(
                  child: Text(
                    '空',
                    style: TextStyle(
                      fontSize: 16.w,
                      color: Colors.black54,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: children,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  CardWrapper dir(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('文件夹'),
          SizedBox(
            height: 4.w,
          ),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(
            height: 10.w,
          ),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity name in ctl.dirFiles) {
                  children.add(
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            '${fm.Config.packagePrefix}assets/icon/dir.svg',
                            width: 32.w,
                            height: 32.w,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 8.w,
                          ),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(name.path),
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CardWrapper imgFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title('图片'),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity name in ctl.imgFiles) {
                  children.add(
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(name.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(name.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 20.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CardWrapper apkFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title('安装包'),
          SizedBox(
            height: 4.w,
          ),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(
            height: 4.w,
          ),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                if (GetPlatform.isDesktop) {
                  return const SizedBox();
                }
                List<Widget> children = [];
                for (FileSystemEntity name in ctl.apkFiles) {
                  children.add(
                    SizedBox(
                      width: 40.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              OpenFile.open(name.path);
                            },
                            child: Image.network(
                              'http://127.0.0.1:${(Global().appChannel as LocalAppChannel).getPort()}/icon?path=${name.path}',
                              gaplessPlayback: true,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return const SizedBox();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 8.w,
                          ),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(name.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 20.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CardWrapper docFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('文档'),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity file in ctl.docFiles) {
                  children.add(
                    SizedBox(
                      // color: Colors.red,
                      width: 64.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(file.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                height: 1.0,
                                color: Colors.black,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CardWrapper zipFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('压缩包'),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity file in ctl.zipFiles) {
                  children.add(
                    SizedBox(
                      // color: Colors.red,
                      width: 64.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(file.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Center title(String data) {
    return Center(
      child: Text(
        data,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 16.w,
        ),
      ),
    );
  }

  CardWrapper onknownFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('未知格式'),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity file in ctl.onknown) {
                  children.add(
                    SizedBox(
                      width: 64.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              path.basename(file.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardWrapper extends StatelessWidget {
  const CardWrapper({
    Key key,
    this.child,
    this.padding,
  }) : super(key: key);
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 120.w,
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: 4.w,
            horizontal: 12.w,
          ),
      child: child,
    );
  }
}
