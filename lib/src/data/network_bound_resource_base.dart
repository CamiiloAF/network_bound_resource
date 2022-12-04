import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../domain/entities/entities.dart';
import 'connectivity_service.dart';
import 'database_handler.dart';
import 'http_proxy_impl.dart';

abstract class NetworkBoundResourceBase {
  final ConnectivityService connectivityService;
  final HttpProxyImpl httpProxyImpl;
  final DataBaseHandler dataBaseHandler;

  static const _syncDataTableName = 'syncData';

  NetworkBoundResourceBase(
      this.connectivityService, this.httpProxyImpl, this.dataBaseHandler) {
    connectivityService.listenDeviceConnectivity((result) async {
      if (result != ConnectivityResult.none) {
        await syncData();
      }
    });
  }

  Future<Response<dynamic>> executeGet({
    required String path,
    required String tableName,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final isThereConnection = await connectivityService.isThereConnection();

    if (!isThereConnection) {
      return await _getDataFromLocal(tableName, path);
    }

    final response = await httpProxyImpl.instance().get(
          path,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options,
          queryParameters: queryParameters,
        );

    dataBaseHandler.clearTable(tableName);

    if (response.data is Iterable) {
      for (var element in response.data) {
        dataBaseHandler.saveLocalData(element, tableName);
      }
    } else {
      dataBaseHandler.saveLocalData(response.data, tableName);
    }
    return response;
  }

  Future<Response<dynamic>> _getDataFromLocal(
      String tableName, String path) async {
    final localData = await dataBaseHandler.getLocalData(tableName);

    final dataToResponse = localData.length == 1 ? localData[0] : localData;

    return Response(
      requestOptions: RequestOptions(path: path),
      data: dataToResponse,
    );
  }

  Future<Response<dynamic>> executePost({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final isThereConnection = await connectivityService.isThereConnection();

    if (!isThereConnection) {
      _onNoConnection(data, path, HttpMethod.post.name);
    }

    final response = await httpProxyImpl.instance().post(
          path,
          data: data,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
        );

    return response;
  }

  Future<Response<dynamic>> executePut({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final isThereConnection = await connectivityService.isThereConnection();

    if (!isThereConnection) {
      return await _onNoConnection(data, path, HttpMethod.put.name);
    }

    final response = await httpProxyImpl.instance().put(
          path,
          data: data,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
        );

    return response;
  }

  Future<Response<dynamic>> executeDelete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final isThereConnection = await connectivityService.isThereConnection();

    if (!isThereConnection) {
      return await _onNoConnection(data, path, HttpMethod.delete.name);
    }

    final response = await httpProxyImpl.instance().delete(
          path,
          data: data,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters,
        );

    return response;
  }

  Future<Response<dynamic>> executePatch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final isThereConnection = await connectivityService.isThereConnection();

    if (!isThereConnection) {
      return await _onNoConnection(data, path, HttpMethod.patch.name);
    }

    final response = await httpProxyImpl.instance().patch(
          path,
          data: data,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );

    return response;
  }

  Future<void> syncData() async {
    final data = await dataBaseHandler.getLocalData(_syncDataTableName);
    for (final element in data) {
      final elementToBeSync = SyncDataEntity.fromJson(element);

      if (elementToBeSync.method == HttpMethod.post.name) {
        await executePost(
          path: elementToBeSync.path,
          data: elementToBeSync.data,
          queryParameters: elementToBeSync.queryParameters,
        );
      } else if (elementToBeSync.method == HttpMethod.patch.name) {
        await executePatch(
          path: elementToBeSync.path,
          data: elementToBeSync.data,
          queryParameters: elementToBeSync.queryParameters,
        );
      } else if (elementToBeSync.method == HttpMethod.put.name) {
        await executePut(
          path: elementToBeSync.path,
          data: elementToBeSync.data,
          queryParameters: elementToBeSync.queryParameters,
        );
      } else if (elementToBeSync.method == HttpMethod.delete.name) {
        await executeDelete(
          path: elementToBeSync.path,
          data: elementToBeSync.data,
          queryParameters: elementToBeSync.queryParameters,
        );
      }
    }

    await dataBaseHandler.clearTable(_syncDataTableName);
  }

  Future<Response<dynamic>> _onNoConnection(
      data, String path, String httpMethod) async {
    final syncDataEntity = SyncDataEntity(
      data: data,
      path: path,
      method: httpMethod,
    );
    await _saveDataToBeSync(syncDataEntity);

    return Response(
      requestOptions: RequestOptions(path: path),
    );
  }

  Future<void> _saveDataToBeSync(SyncDataEntity syncDataEntity) async {
    await dataBaseHandler.saveLocalData(
        syncDataEntity.toJson(), _syncDataTableName);
  }
}
