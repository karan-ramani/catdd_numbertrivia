import 'dart:convert';

import 'package:catdd_numbertrivia/core/error/exceptions.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final String url = 'http://numbersapi.com/$number';

    return await _getRemoteTrivia(url);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getRemoteTrivia('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getRemoteTrivia(String url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return NumberTriviaModel.fromJson(jsonDecode(response.body.toString()));
    }
  }
}
