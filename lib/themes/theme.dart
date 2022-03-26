export 'default_theme_data.dart';
export 'color_extension.dart';

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

FontWeight bold = GetPlatform.isLinux ? null : FontWeight.bold;
