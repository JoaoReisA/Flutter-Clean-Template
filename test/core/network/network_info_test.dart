import 'package:clean_arch_reso/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should foward the call to DataConnectionChecker.hasConnection', () async{
      final tHasConnectionFuture = Future.value(true);
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((invocation)  => tHasConnectionFuture);

          final result =  networkInfoImpl.isConnected;

          verify(() => mockDataConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
    });
  });
}
