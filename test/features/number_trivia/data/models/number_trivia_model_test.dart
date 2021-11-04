import 'dart:convert';

import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test Text');
  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should return a valid model when JSON number is an integer', () {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
    test('Should return a valid model when JSON number is regarded as a double',
        () {
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Shoud return a JSON map containing the proper data', () {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
