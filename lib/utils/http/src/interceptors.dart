part of http;

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.connectTimeout = 1000 * 15;
    options.receiveTimeout = 10000 * 15;
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    DioUtils.cancelToken = null;
    return handler.next(response);
  }
}

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.response:
        String message = '';
        final String content = err.response.data.toString();
        // Log.d(err.response.data.runtimeType);
        // Log.d('$this ------>content---->$content');
        if (content != '') {
          // Log.d('content不为空');
          try {
            // Log.d(err.response.data.toString());
            final Map<String, dynamic> decode = err.response.data as Map<String, dynamic>;
            message = decode['error'] as String;
          } catch (error) {
            message = error.toString();
          }
        }

        // Log.d('$this ---->$message');
        final int status = err.response.statusCode;

        switch (status) {
          case HttpStatus.badRequest:
            throw AuthorizationException(status: status, message: message);
            break;
          case HttpStatus.unauthorized:
            throw AuthorizationException(status: status, message: message);
            break;
          case HttpStatus.forbidden:
            throw AuthorizationException(status: status, message: message);
            break;
          case HttpStatus.networkConnectTimeoutError:
            throw NetworkException(status: status, message: '连接超时');
            break;
          case HttpStatus.unprocessableEntity:
            throw ValidationException(status: status, message: message);
            break;
          default:
            throw StatusException(status: status, message: message);
        }
        break;
      case DioErrorType.cancel:
        DioUtils.cancelToken = null;
        throw CancelRequestException(status: HttpStatus.clientClosedRequest, message: err.toString());
        break;
      default:
        throw NetworkException(status: HttpStatus.networkConnectTimeoutError, message: err.message);
    }
  }
}
