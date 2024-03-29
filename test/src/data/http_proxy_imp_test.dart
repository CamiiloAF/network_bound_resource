import 'package:dio/dio.dart';
import 'package:network_bound_resource/src/data/http_proxy_impl.dart';
import 'package:network_bound_resource/src/data/http_proxy_repository.dart';
import 'package:test/test.dart';

void main() {
  HttpProxyInterface httpProxy;

  const baseUrl = 'https://test/api';

  group('instance', () {
    test(
        'instance should return a Dio instance with baseUrl and empty interceptors when method is invoke',
        () async {
      httpProxy = HttpProxyImpl(baseUrl, interceptors: []);

      final dio = httpProxy.instance();

      expect(dio.options.baseUrl, baseUrl);
      expect(dio.interceptors.length, 1);
    });

    test(
        'instance should return a Dio instance with baseUrl and interceptors when method is invoke',
        () async {
      httpProxy = HttpProxyImpl(baseUrl, interceptors: [const Interceptor()]);

      final dio = httpProxy.instance();

      expect(dio.options.baseUrl, baseUrl);
      expect(dio.interceptors.length, 2);
    });
  });
}
