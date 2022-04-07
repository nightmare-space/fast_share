import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
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
    return Column(
      children: [
        Header(),
        SizedBox(
          height: 10.w,
        ),
        CardWrapper(
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
              GetBuilder<FileController>(
                builder: (ctl) {
                  List<Widget> children = [];
                  for (FileSystemEntity name in ctl.dirFiles) {
                    children.add(
                      SizedBox(
                        width: 40.w,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icon/dir.png',
                              width: 36.w,
                              height: 36.w,
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            Text(
                              basename(name.path),
                              style: TextStyle(
                                fontSize: 6.w,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    children.add(
                      SizedBox(
                        width: 27.w,
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
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CardWrapper(
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
                height: 10.w,
              ),
              GetBuilder<FileController>(
                builder: (ctl) {
                  List<Widget> children = [];
                  for (String name in ctl.onknown) {
                    children.add(
                      SizedBox(
                        width: 40.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icon/other.png',
                              width: 36.w,
                              height: 36.w,
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 6.w,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    children.add(
                      SizedBox(
                        width: 27.w,
                      ),
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
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
                        for (String name in ctl.zipFiles) {
                          children.add(
                            SizedBox(
                              width: 40.w,
                              child: Column(
                                children: [
                                  getIconByExt(extension(name)),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 6.w,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          children.add(
                            SizedBox(
                              width: 27.w,
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
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
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
                      height: 10.w,
                    ),
                    GetBuilder<FileController>(
                      builder: (ctl) {
                        List<Widget> children = [];
                        for (String name in ctl.docFiles) {
                          children.add(
                            SizedBox(
                              width: 40.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  getIconByExt(extension(name)),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 6.w,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          children.add(
                            SizedBox(
                              width: 27.w,
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
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
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
                        for (String name in ctl.audioFiles) {
                          children.add(
                            Column(
                              children: [
                                getIconByExt(extension(name)),
                                SizedBox(
                                  height: 4.w,
                                ),
                                Text(
                                  name,
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
                              width: 27.w,
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
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
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
                      height: 10.w,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
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
                      height: 10.w,
                    ),
                    GetBuilder<FileController>(
                      builder: (ctl) {
                        List<Widget> children = [];
                        for (FileSystemEntity name in ctl.imgFiles) {
                          children.add(
                            Column(
                              children: [
                                Image.file(
                                  File(name.path),
                                  width: 40.w,
                                ),
                                SizedBox(
                                  height: 4.w,
                                ),
                                Text(
                                  basename(name.path),
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
                              width: 27.w,
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
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
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
                      height: 10.w,
                    ),
                    Text(
                      '此记事本模块的内容。',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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
      padding: EdgeInsets.all(10.w),
      child: child,
    );
  }
}
