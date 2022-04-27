library document;

export 'document_io.dart' if (dart.library.html) 'document_broswer.dart';

// 用来兼容在客户端使用浏览器的url不报错
// 