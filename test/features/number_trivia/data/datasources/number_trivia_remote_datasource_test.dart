import 'dart:convert';

import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {
  @override
  BaseOptions options;
  MockDio({
    required this.options,
  });
}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockDio mockDio;
  late BaseOptions options;
  setUp(() {
    options = BaseOptions(headers: {'Content-Type': 'application/json'});
    mockDio = MockDio(options: options);
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockDio);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'Should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      when(() => mockDio.get('http://numbersapi.com/$tNumber')).thenAnswer(
          (invocation) async => Response(
              statusCode: 200,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/$tNumber')));
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      verify(() => mockDio.get('http://numbersapi.com/$tNumber'));
    });

    test('Should return NumberTrivia when the response code is 200 (sucess)',
        () async {
      when(() => mockDio.get('http://numbersapi.com/$tNumber')).thenAnswer(
          (invocation) async => Response(
              statusCode: 200,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/$tNumber')));
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      when(() => mockDio.get('http://numbersapi.com/$tNumber')).thenAnswer(
          (invocation) async => Response(
              statusCode: 404,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/$tNumber')));
      final call = dataSourceImpl.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

    group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'Should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      when(() => mockDio.get('http://numbersapi.com/random')).thenAnswer(
          (invocation) async => Response(
              statusCode: 200,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/random')));
      dataSourceImpl.getRandomNumberTrivia();
      verify(() => mockDio.get('http://numbersapi.com/random'));
    });

    test('Should return NumberTrivia when the response code is 200 (sucess)',
        () async {
      when(() => mockDio.get('http://numbersapi.com/random')).thenAnswer(
          (invocation) async => Response(
              statusCode: 200,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/random')));
      final result = await dataSourceImpl.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      when(() => mockDio.get('http://numbersapi.com/random')).thenAnswer(
          (invocation) async => Response(
              statusCode: 404,
              data: fixture('trivia.json'),
              requestOptions: RequestOptions(path: '/random')));
      final call = dataSourceImpl.getRandomNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
