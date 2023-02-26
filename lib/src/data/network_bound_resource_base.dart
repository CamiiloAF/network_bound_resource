// ignore_for_file: avoid_annotating_with_dynamic

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../domain/entities/entities.dart';
import 'connectivity_service.dart';
import 'database_handler.dart';
import 'http_proxy_impl.dart';

/// This class automatically decides where it should get the data from,
/// if you have internet connection the data will be loaded from your backend,
/// otherwise the data will be loaded from local storage or saved to it if the
/// request is a POST, PUT or DELETE.
///
/// You have to loaded the information at least one time.
abstract class NetworkBoundResourceBase {
  final ConnectivityService _connectivityService;
  final HttpProxyImpl _httpProxyImpl;
  final DataBaseHandler _dataBaseHandler;

  static const _syncDataTableName = 'syncData';

  NetworkBoundResourceBase({
    required ConnectivityService connectivityService,
    required HttpProxyImpl httpProxyImpl,
    required DataBaseHandler dataBaseHandler,
  })  : _connectivityService = connectivityService,
        _httpProxyImpl = httpProxyImpl,
        _dataBaseHandler = dataBaseHandler {
    _connectivityService.listenDeviceConnectivity(
      (result) async {
        if (result != ConnectivityResult.none) {
          await syncData();
        }
      },
    );
  }

  /// Returns true if the device is connected to internet
  Future<bool> isThereConnection() async =>
      _connectivityService.isThereConnection();

  /// Make a GET request
  ///
  /// [tableName] is the name of table where the data will be stored or loaded
  /// depending of internet connection state
  ///
  /// If you only need to get 1 item and not a list,
  /// when the device isn't connect to internet,
  /// you have to send true on [getFromLocalAsAList]
  Future<Response<dynamic>> executeGet({
    required String path,
    required String tableName,
    Map<String, dynamic>? queryParameters,
    bool getFromLocalAsAList = false,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final isThereConnection = await _connectivityService.isThereConnection();

    if (!isThereConnection) {
      return _getDataFromLocal(
        tableName,
        path,
        getFromLocalAsAList: getFromLocalAsAList,
      );
    }

    final response = await _httpProxyImpl.instance().get(
          path,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options,
          queryParameters: queryParameters,
        );

    await clearTable(tableName);

    if (response.data is Iterable) {
      for (final element in response.data) {
        await _dataBaseHandler.saveLocalData(element, tableName);
      }
    } else {
      await _dataBaseHandler.saveLocalData(response.data, tableName);
    }
    return response;
  }

  /// Make a POST request
  Future<Response<dynamic>> executePost({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool syncDataIfNoConnection = true,
  }) async {
    final isThereConnection = await _connectivityService.isThereConnection();

    if (!isThereConnection && syncDataIfNoConnection) {
      return _onNoConnection(data, path, HttpMethod.post.name);
    }

    final response = await _httpProxyImpl.instance().post(
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

  /// Make a PUT request
  Future<Response<dynamic>> executePut({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool syncDataIfNoConnection = true,
  }) async {
    final isThereConnection = await _connectivityService.isThereConnection();

    if (!isThereConnection && syncDataIfNoConnection) {
      return _onNoConnection(data, path, HttpMethod.put.name);
    }

    final response = await _httpProxyImpl.instance().put(
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

  /// Make a DELETE request
  Future<Response<dynamic>> executeDelete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool syncDataIfNoConnection = true,
  }) async {
    final isThereConnection = await _connectivityService.isThereConnection();

    if (!isThereConnection && syncDataIfNoConnection) {
      return _onNoConnection(data, path, HttpMethod.delete.name);
    }

    final response = await _httpProxyImpl.instance().delete(
          path,
          data: data,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters,
        );

    return response;
  }

  /// Make a PATCH request
  Future<Response<dynamic>> executePatch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool syncDataIfNoConnection = true,
  }) async {
    final isThereConnection = await _connectivityService.isThereConnection();

    if (!isThereConnection && syncDataIfNoConnection) {
      return _onNoConnection(data, path, HttpMethod.patch.name);
    }

    final response = await _httpProxyImpl.instance().patch(
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

  /// Sync all local data when the device regains internet connection
  ///
  /// This action is executed automatically when the device connects to the internet
  Future<void> syncData() async {
    final data = await _dataBaseHandler.getLocalData(_syncDataTableName);
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

    await clearTable(_syncDataTableName);
  }

  /// Load data from database table.
  Future<Response<dynamic>> _getDataFromLocal(String tableName, String path,
      {required bool getFromLocalAsAList}) async {
    final localData = await _dataBaseHandler.getLocalData(tableName);

    final dataToResponse = localData.length == 1 && !getFromLocalAsAList
        ? localData[0]
        : localData;

    return Response(
      requestOptions: RequestOptions(path: path),
      data: dataToResponse,
    );
  }

  /// Save data in database when the user tries to make and http request but
  /// the device isn't internet connection.
  Future<Response<dynamic>> _onNoConnection(
    data,
    String path,
    String httpMethod,
  ) async {
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

  /// Save a [SyncDataEntity] in the database
  Future<void> _saveDataToBeSync(SyncDataEntity syncDataEntity) async {
    await saveLocalData(
      _syncDataTableName,
      syncDataEntity.toJson(),
    );
  }

  /// Save data in local db
  Future<void> saveLocalData(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    await _dataBaseHandler.saveLocalData(data, tableName);
  }

  /// Clear a table on local db
  Future<void> clearTable(String tableName) async {
    await _dataBaseHandler.clearTable(tableName);
  }
}
