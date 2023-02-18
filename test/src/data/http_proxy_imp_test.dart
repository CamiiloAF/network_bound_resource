import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_bound_resource/src/data/connectivity_service.dart';
import 'package:test/test.dart';

import 'connectivity_service_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late ConnectivityService connectivityService;
  late Connectivity connectivity;

  setUp(() {
    connectivity = MockConnectivity();
    connectivityService = ConnectivityService(connectivity: connectivity);
  });

  group('isThereConnection', () {
    test(
        'isThereConnection should return true when ConnectivityResult is "wifi"',
        () async {
      when(connectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);

      final isThereConnection = await connectivityService.isThereConnection();

      expect(isThereConnection, isTrue);
    });
  });

  test(
      'isThereConnection should return true when ConnectivityResult is "mobile"',
      () async {
    when(connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);

    final isThereConnection = await connectivityService.isThereConnection();

    expect(isThereConnection, isTrue);
  });

  test(
      'isThereConnection should return true when ConnectivityResult is "ethernet"',
      () async {
    when(connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.ethernet);

    final isThereConnection = await connectivityService.isThereConnection();

    expect(isThereConnection, isTrue);
  });

  test('isThereConnection should return true when ConnectivityResult is "vpn"',
      () async {
    when(connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.vpn);

    final isThereConnection = await connectivityService.isThereConnection();

    expect(isThereConnection, isTrue);
  });

  test(
      'isThereConnection should return false when ConnectivityResult is "none"',
      () async {
    when(connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);

    final isThereConnection = await connectivityService.isThereConnection();

    expect(isThereConnection, isFalse);
  });

  test(
      'isThereConnection should return false when ConnectivityResult is "bluetooth"',
      () async {
    when(connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.bluetooth);

    final isThereConnection = await connectivityService.isThereConnection();

    expect(isThereConnection, isFalse);
  });

  group('listenDeviceConnectivity', () {
    Future<void> onData(ConnectivityResult result) async {
      expect(result, ConnectivityResult.ethernet);
    }

    test('listenDeviceConnectivity should not throw an exception', () {
      when(connectivity.onConnectivityChanged).thenAnswer((_) async* {
        yield ConnectivityResult.ethernet;
      });
      connectivityService.listenDeviceConnectivity(onData);
    });
  });
}
