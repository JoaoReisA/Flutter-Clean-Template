import 'dart:convert';

import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'Should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSourceImpl.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
    test('Should throw a CacheException when there is not a cached value',
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = dataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences
          .setString(CACHED_NUMBER_TRIVIA, any()))
          .thenAnswer((value) async => true);

      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
