import 'package:dio/dio.dart';

/// HTTP client interface
abstract class HttpProxyInterface {
  Dio instance();
}
