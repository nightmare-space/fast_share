import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:app_manager/global/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:speed_share/app/controller/file_controller.dart';

import 'header.dart';
import 'icon.dart';

class FilePage extends StatefulWidget {
  const FilePage({Key key}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            SizedBox(height: 10.w),
            dir(context),
            const SizedBox(height: 10),
            onknownFile(context),
            const SizedBox(height: 10),
            Row(
              children: [
                zipFile(context),
                const SizedBox(width: 10),
                docFile(context),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                audio(context),
                SizedBox(width: 10.w),
                video(context),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                imgFile(context),
                const SizedBox(width: 10),
                apkFile(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded video(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '视频',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.w,
                ),
              ),
            ),
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
                        width: 40.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getIconByExt(name.path),
                            SizedBox(height: 4.w),
                            SizedBox(
                              height: 14.w,
                              child: Text(
                                basename(name.path),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 6.w,
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
      ),
    );
  }

  Expanded audio(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '音乐',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.w,
                ),
              ),
            ),
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
                          basename(file.path),
                          style: TextStyle(
                            fontSize: 6.w,
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
      ),
    );
  }

  CardWrapper dir(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Text(
              '文件夹',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 14.w,
              ),
            ),
          ),
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
                      width: 40.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon/dir.png',
                            width: 36.w,
                            height: 36.w,
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          SizedBox(
                            height: 14.w,
                            child: Text(
                              basename(name.path),
                              style: TextStyle(
                                fontSize: 6.w,
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
                      width: 20.w,
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

  Expanded imgFile(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '图片',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 14.w,
              ),
            ),
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
                  for (FileSystemEntity name in ctl.imgFiles) {
                    children.add(
                      SizedBox(
                        width: 40.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getIconByExt(name.path),
                            SizedBox(height: 4.w),
                            SizedBox(
                              height: 14.w,
                              child: Text(
                                basename(name.path),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 6.w,
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
      ),
    );
  }

  Expanded apkFile(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '安装包',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 14.w,
              ),
            ),
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
                              height: 4.w,
                            ),
                            SizedBox(
                              height: 14.w,
                              child: Text(
                                basename(name.path),
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 6.w,
                                    color: Colors.black,
                                    height: 1.0),
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
      ),
    );
  }

  Expanded docFile(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '文档',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.w,
                ),
              ),
            ),
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
                  for (FileSystemEntity file in ctl.docFiles) {
                    children.add(
                      SizedBox(
                        width: 40.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getIconByExt(file.path),
                            SizedBox(height: 4.w),
                            SizedBox(
                              height: 14.w,
                              child: Text(
                                basename(file.path),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 6.w,
                                  height: 1.0,
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
                        width: 20.w,
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
      ),
    );
  }

  Expanded zipFile(BuildContext context) {
    return Expanded(
      child: CardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '压缩包',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.w,
                ),
              ),
            ),
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
                      Container(
                        // color: Colors.red,
                        width: 40.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            getIconByExt(file.path),
                            SizedBox(height: 4.w),
                            SizedBox(
                              height: 14.w,
                              child: Text(
                                basename(file.path),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 6.w,
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
                        width: 20.w,
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
      ),
    );
  }

  CardWrapper onknownFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '未知格式',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
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
                for (FileSystemEntity file in ctl.onknown) {
                  children.add(
                    SizedBox(
                      width: 40.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 4.w),
                          SizedBox(
                            height: 14.w,
                            child: Text(
                              basename(file.path),
                              style: TextStyle(
                                fontSize: 6.w,
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
                      width: 20.w,
                    ),
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
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
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 104.w,
      padding: EdgeInsets.symmetric(
        vertical: 4.w,
        horizontal: 12.w,
      ),
      child: child,
    );
  }
}
