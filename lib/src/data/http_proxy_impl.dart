import 'package:dio/dio.dart';

import 'http_proxy_repository.dart';

/// Set up client HTTP to make HTTP requests
///
/// You can use this class to make an HTTP request that does not require
/// synchronization
/// [HttpProxyImpl().instance().get(...)]
class HttpProxyImpl extends HttpProxyInterface {
  late Dio _http;
  final String baseUrl;
  final List<Interceptor>? interceptors;

  HttpProxyImpl(this.baseUrl, {this.interceptors}) {
    _http = Dio()
      ..interceptors.addAll(interceptors ?? [])
      ..options.connectTimeout = 40000
      ..options.receiveTimeout = 40000
      ..options.sendTimeout = 3000
      ..options.baseUrl = baseUrl;
  }

  @override
  Dio instance() => _http;
}
