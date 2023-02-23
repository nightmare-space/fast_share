library http;

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:signale/signale.dart';
part 'src/exception.dart';
part 'src/dio_utils.dart';
part 'src/interceptors.dart';

// 一个dio的全局单例
Dio? httpInstance = DioUtils.getInstance();
