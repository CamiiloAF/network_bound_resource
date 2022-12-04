import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'connectivity_service.dart';
import 'database_handler.dart';
import 'http_proxy_impl.dart';
import 'network_bound_resource_base.dart';

class NetworkBoundResource extends NetworkBoundResourceBase {
  NetworkBoundResource(String baseUrl, {List<Interceptor>? interceptors})
      : super(
          connectivityService: ConnectivityService(
            connectivity: Connectivity(),
          ),
          httpProxyImpl: HttpProxyImpl(baseUrl, interceptors: interceptors),
          dataBaseHandler: DataBaseHandler(),
        );
}
