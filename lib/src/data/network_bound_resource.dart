import 'package:dio/dio.dart';

import '../../network_bound_resource.dart';
import 'connectivity_service.dart';
import 'database_handler.dart';
import 'http_proxy_impl.dart';

class NetworkBoundResource extends NetworkBoundResourceBase {
  NetworkBoundResource(String baseUrl, {List<Interceptor>? interceptors})
      : super(
          ConnectivityService(),
          HttpProxyImpl(
            baseUrl,
            interceptors: interceptors,
          ),
          DataBaseHandler(),
        );
}