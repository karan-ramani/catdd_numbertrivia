import 'dart:convert';

import 'package:catdd_numbertrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: 1, trivia: 'test text');

  test('Should be a subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should recevie a json object - integer is received in json',
        () async {
      //arrange
      final Map<String, dynamic> jsonMapInt =
          jsonDecode(readFixture('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMapInt);

      //assert
      expect(result, tNumberTriviaModel);
    });

    test('Should recevie a json object - double is received in json', () async {
      //arrange
      final Map<String, dynamic> jsonMapDouble =
          jsonDecode(readFixture('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMapDouble);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should return a json map of number and trivia', () {
      //act
      final expectedMap = {'number': 1, 'text': 'test text'};
      final result = tNumberTriviaModel.toJson();

      //assert
      expect(result, expectedMap);
    });
  });
}
