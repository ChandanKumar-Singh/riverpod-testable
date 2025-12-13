import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:testable/core/network/network_info.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  group('NetworkInfoImpl', () {
    late NetworkInfoImpl networkInfo;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      networkInfo = NetworkInfoImpl(mockConnectivity);
    });

    test('isConnected returns true when connected', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfo.isConnected;
      expect(result, isTrue);
    });

    test('isConnected returns true for mobile connection', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      final result = await networkInfo.isConnected;
      expect(result, isTrue);
    });

    test('isConnected returns false when not connected', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await networkInfo.isConnected;
      expect(result, isFalse);
    });

    test('isConnected returns true for multiple connections', () async {
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
      );

      final result = await networkInfo.isConnected;
      expect(result, isTrue);
    });

    test('isConnected returns false when all are none', () async {
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none, ConnectivityResult.none],
      );

      final result = await networkInfo.isConnected;
      expect(result, isFalse);
    });
  });
}
