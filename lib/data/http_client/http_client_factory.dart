import 'package:dio/dio.dart';

// ignore: one_member_abstracts
abstract class HttpClientFactory {
  Dio createHttpClient();
}
