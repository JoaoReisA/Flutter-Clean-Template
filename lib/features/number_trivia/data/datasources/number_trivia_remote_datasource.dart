import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio client;
  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    client.options.headers['Content-Type'] = 'application/json';
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.data));
    } else {
      throw ServerException();
    }
  }
}
