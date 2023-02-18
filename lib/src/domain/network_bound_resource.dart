import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../data/connectivity_service.dart';
import '../data/database_handler.dart';
import '../data/http_proxy_impl.dart';
import '../data/network_bound_resource_base.dart';

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
