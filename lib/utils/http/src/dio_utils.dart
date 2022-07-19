part of http;

class DioUtils {
  DioUtils._();
  static Dio _instance;
  static CancelToken cancelToken;

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio();
      _instance.interceptors.add(HeaderInterceptor());
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
