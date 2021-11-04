import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/core/error/failures.dart';
import 'package:clean_arch_reso/core/network/network_info.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_reso/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => false);
      });
      body();
    });
  }

  group('getCOncreteNumberTrivia', () {
    const tNumber = 1;
    const tNUmberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNUmberTriviaModel;
    test('Should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((invocation) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((invocation) async => tNUmberTriviaModel);
      await repository.getConcreteNumberTrivia(tNumber);

      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is sucess',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          'should cache the data localy when the call to remote data source is sucess',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNUmberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsucessful',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNUmberTriviaModel)));
      });
      test('should return [CacheFailure] when the cached data is not present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNUmberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 123);
    const NumberTrivia tNumberTrivia = tNUmberTriviaModel;
    test('Should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((invocation) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((invocation) async => tNUmberTriviaModel);
      await repository.getRandomNumberTrivia();

      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is sucess',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          'should cache the data localy when the call to remote data source is sucess',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNUmberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsucessful',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNUmberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNUmberTriviaModel)));
      });
      test('should return [CacheFailure] when the cached data is not present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
