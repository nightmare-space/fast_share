part of http;

class DioUtils {
  DioUtils._();
  static Dio _instance;
  static CancelToken cancelToken;

  static Dio getInstance() {
    if (_instance == null) {
      BaseOptions options = BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 60 * 1000, // 60 seconds
          receiveTimeout: 60 * 1000 // 60 seconds
          );

      _instance = Dio(options);
      _instance.interceptors.add(HeaderInterceptor());
      _instance.options.connectTimeout = 5000; //超时时间
      _instance.options.receiveTimeout = 5000; //接收数据最长时间
      _instance.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // print(options.extra);
            Log.v('>>>>>>>>HTTP LOG');
            Log.v(options.uri);
            Log.v(options.method);
            Log.v(options.headers);
            Log.v('<<<<<<<<');
            handler.next(options);
          },
        ),
      );
      _instance.interceptors.add(ErrorInterceptor());
    }
    return _instance;
  }
}
