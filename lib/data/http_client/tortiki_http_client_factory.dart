import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'http_client_factory.dart';

class TortikiHttpClientFactory implements HttpClientFactory {
  final _baseUrl = 'https://tortiki/api';
  @override
  Dio createHttpClient() {
    final options = BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000);
    final dio = Dio(options);
    var interceptors = <Interceptor>[
      LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) {
            debugPrint('[HTTP CLIENT] ${object.toString()}');
          }),
    ];
    dio.interceptors.addAll(interceptors);
    return dio;
  }
}
