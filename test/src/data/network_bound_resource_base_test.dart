import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_bound_resource/src/data/connectivity_service.dart';
import 'package:network_bound_resource/src/data/database_handler.dart';
import 'package:network_bound_resource/src/data/http_proxy_impl.dart';
import 'package:network_bound_resource/src/data/network_bound_resource_base.dart';
import 'package:network_bound_resource/src/domain/entities/entities.dart';
import 'package:test/test.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

class MockHttpProxyImpl extends Mock implements HttpProxyImpl {}

class MockDataBaseHandler extends Mock implements DataBaseHandler {}

class MockDio extends Mock implements Dio {}

class NetworkBoundResourceTest extends NetworkBoundResourceBase {
  NetworkBoundResourceTest(
      {required super.connectivityService,
      required super.httpProxyImpl,
      required super.dataBaseHandler});
}

void main() {
  late ConnectivityService connectivityService;
  late HttpProxyImpl httpProxyImpl;
  late DataBaseHandler dataBaseHandler;
  late Dio dio;

  late NetworkBoundResourceBase networkBoundResourceBase;

  setUp(() {
    connectivityService = MockConnectivityService();
    httpProxyImpl = MockHttpProxyImpl();
    dataBaseHandler = MockDataBaseHandler();
    dio = MockDio();

    when(() => httpProxyImpl.instance()).thenReturn(dio);
    when(() => dataBaseHandler.clearTable(any())).thenAnswer((_) async {});

    networkBoundResourceBase = NetworkBoundResourceTest(
      connectivityService: connectivityService,
      httpProxyImpl: httpProxyImpl,
      dataBaseHandler: dataBaseHandler,
    );
  });

  group('syncData', () {
    test(
      'syncData should invoke clearTable and executePost when HttpMethod is POST',
      () async {
        final databaseData = {
          'path': 'path',
          'data': {'id': 2},
          'method': HttpMethod.post.name,
          'queryParameters': null,
        };

        when(() => dataBaseHandler.getLocalData(any()))
            .thenAnswer((_) async => [databaseData]);

        when(() => connectivityService.isThereConnection())
            .thenAnswer((_) async => true);

        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        await networkBoundResourceBase.syncData();

        verify(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).called(1);

        verify(() => dataBaseHandler.clearTable(any())).called(1);
      },
    );

    test(
      'syncData should invoke clearTable and executePatch when HttpMethod is PATCH',
      () async {
        final databaseData = {
          'path': 'path',
          'data': {'id': 2},
          'method': HttpMethod.patch.name,
          'queryParameters': null,
        };

        when(() => dataBaseHandler.getLocalData(any()))
            .thenAnswer((_) async => [databaseData]);

        when(() => connectivityService.isThereConnection())
            .thenAnswer((_) async => true);

        when(
          () => dio.patch(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        await networkBoundResourceBase.syncData();

        verify(
          () => dio.patch(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).called(1);

        verify(() => dataBaseHandler.clearTable(any())).called(1);
      },
    );

    test(
      'syncData should invoke clearTable and executePut when HttpMethod is PUT',
      () async {
        final databaseData = {
          'path': 'path',
          'data': {'id': 2},
          'method': HttpMethod.put.name,
          'queryParameters': null,
        };

        when(() => dataBaseHandler.getLocalData(any()))
            .thenAnswer((_) async => [databaseData]);

        when(() => connectivityService.isThereConnection())
            .thenAnswer((_) async => true);

        when(
          () => dio.put(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        await networkBoundResourceBase.syncData();

        verify(
          () => dio.put(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).called(1);

        verify(() => dataBaseHandler.clearTable(any())).called(1);
      },
    );

    test(
      'syncData should invoke clearTable and executeDelete when HttpMethod is DELETE',
      () async {
        final databaseData = {
          'path': 'path',
          'data': {'id': 2},
          'method': HttpMethod.delete.name,
          'queryParameters': null,
        };

        when(() => dataBaseHandler.getLocalData(any()))
            .thenAnswer((_) async => [databaseData]);

        when(() => connectivityService.isThereConnection())
            .thenAnswer((_) async => true);

        when(
          () => dio.delete(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        await networkBoundResourceBase.syncData();

        verify(
          () => dio.delete(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);

        verify(() => dataBaseHandler.clearTable(any())).called(1);
      },
    );

    test(
      'syncData should invoke clearTable 2 times and executeDelete and executePost when HttpMethod is DELETE and POST',
      () async {
        final databaseData = [
          {
            'path': 'path',
            'data': {'id': 2},
            'method': HttpMethod.delete.name,
            'queryParameters': null,
          },
          {
            'path': 'path',
            'data': {'id': 2},
            'method': HttpMethod.post.name,
            'queryParameters': null,
          },
        ];

        when(() => dataBaseHandler.getLocalData(any()))
            .thenAnswer((_) async => databaseData);

        when(() => connectivityService.isThereConnection())
            .thenAnswer((_) async => true);

        when(
          () => dio.delete(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'path',
            ),
          ),
        );

        await networkBoundResourceBase.syncData();

        verify(
          () => dio.delete(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);

        verify(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).called(1);

        verify(() => dataBaseHandler.clearTable(any())).called(1);
      },
    );
  });

  group('executeGet', () {
    test(
        'Should load data success from network when there is internet connection',
        () async {
      const path = 'users';
      const tableName = 'users';
      final responseData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => true);

      when(
        () => dio.get(
          any(),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          requestOptions: RequestOptions(path: path),
        ),
      );

      when(() => dataBaseHandler.clearTable(any())).thenAnswer((_) async {});

      when(() => dataBaseHandler.saveLocalData(any(), tableName))
          .thenAnswer((_) async {});

      final response = await networkBoundResourceBase.executeGet(
        path: path,
        tableName: tableName,
      );

      verify(() => dataBaseHandler.clearTable(tableName)).called(1);
      verifyNever(() => dataBaseHandler.getLocalData(tableName));
      verify(() => dataBaseHandler.saveLocalData(responseData.first, tableName))
          .called(1);
      expect(response.data, isNotEmpty);
    });

    test(
        'Should load a list of data from local when there is not internet connection',
        () async {
      const path = 'users';
      const tableName = 'users';
      final responseData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.clearTable(any())).thenAnswer((_) async {});

      when(() => dataBaseHandler.saveLocalData(any(), tableName))
          .thenAnswer((_) async {});

      when(() => dataBaseHandler.getLocalData(tableName))
          .thenAnswer((_) async => responseData);

      final response = await networkBoundResourceBase.executeGet(
        path: path,
        tableName: tableName,
        getFromLocalAsAList: true,
      );

      verifyNever(() => dataBaseHandler.clearTable(tableName));
      verifyNever(
          () => dataBaseHandler.saveLocalData(responseData.first, tableName));

      expect(response.data, responseData);
    });

    test(
        'Should load one item from local when there is not internet connection and getFromLocalAsAList is false and local data only have 1 item',
        () async {
      const path = 'users';
      const tableName = 'users';
      final responseData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.clearTable(any())).thenAnswer((_) async {});

      when(() => dataBaseHandler.saveLocalData(any(), tableName))
          .thenAnswer((_) async {});

      when(() => dataBaseHandler.getLocalData(tableName))
          .thenAnswer((_) async => responseData);

      final response = await networkBoundResourceBase.executeGet(
        path: path,
        tableName: tableName,
      );

      verifyNever(() => dataBaseHandler.clearTable(tableName));
      verifyNever(
          () => dataBaseHandler.saveLocalData(responseData.first, tableName));

      expect(response.data, responseData.first);
    });
  });

  group('executePost', () {
    test('Should invoke Dio.post when there is internet connection', () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => true);

      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
        ),
      );

      final response = await networkBoundResourceBase.executePost(
        path: path,
        data: requestData,
      );

      verifyNever(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });

    test('Should save data on local when there is not internet connection',
        () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.saveLocalData(any(), any()))
          .thenAnswer((_) async {});

      final response = await networkBoundResourceBase.executePost(
        path: path,
        data: requestData,
      );

      verify(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });
  });

  group('executePut', () {
    test('Should invoke Dio.put when there is internet connection', () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => true);

      when(
        () => dio.put(
          any(),
          data: any(named: 'data'),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
        ),
      );

      final response = await networkBoundResourceBase.executePut(
        path: path,
        data: requestData,
      );

      verifyNever(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });

    test('Should save data on local when there is not internet connection',
        () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.saveLocalData(any(), any()))
          .thenAnswer((_) async {});

      final response = await networkBoundResourceBase.executePut(
        path: path,
        data: requestData,
      );

      verify(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });
  });

  group('executeDelete', () {
    test('Should invoke Dio.delete when there is internet connection',
        () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => true);

      when(
        () => dio.delete(
          any(),
          data: any(named: 'data'),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
        ),
      );

      final response = await networkBoundResourceBase.executeDelete(
        path: path,
        data: requestData,
      );

      verifyNever(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });

    test('Should save request on local when there is not internet connection',
        () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.saveLocalData(any(), any()))
          .thenAnswer((_) async {});

      final response = await networkBoundResourceBase.executeDelete(
        path: path,
        data: requestData,
      );

      verify(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });
  });

  group('executePatch', () {
    test('Should invoke Dio.patch when there is internet connection', () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => true);

      when(
        () => dio.patch(
          any(),
          data: any(named: 'data'),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: path),
        ),
      );

      final response = await networkBoundResourceBase.executePatch(
        path: path,
        data: requestData,
      );

      verifyNever(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });

    test('Should save request on local when there is not internet connection',
        () async {
      const path = 'users';

      final requestData = <Map<String, dynamic>>[
        {'userId': 102}
      ];

      when(() => connectivityService.isThereConnection())
          .thenAnswer((_) async => false);

      when(() => dataBaseHandler.saveLocalData(any(), any()))
          .thenAnswer((_) async {});

      final response = await networkBoundResourceBase.executePatch(
        path: path,
        data: requestData,
      );

      verify(() => dataBaseHandler.saveLocalData(any(), any()));

      expect(response.requestOptions.path, path);
    });
  });
}
