import 'dart:convert';

import 'package:catdd_numbertrivia/core/error/exceptions.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void serverRequestSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(readFixture('trivia.json'), 200));
  }

  void serverRequestError() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Error 404', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTrivia =
    NumberTriviaModel.fromJson(jsonDecode(readFixture('trivia.json')));

    test('Should send request to URL with JSON content header', () {
      //arrange
      serverRequestSuccess();
      //act
      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return a NumberTriviaModel when sever request successful',
            () async {
          //arrange
          serverRequestSuccess();
          //act
          final result = await numberTriviaRemoteDataSourceImpl
              .getConcreteNumberTrivia(tNumber);
          //assert
          expect(result, tNumberTrivia);
        });

    test('Should return a ServerException when sever request unsuccessful', () {
      //arrange
      serverRequestError();
      //act
      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTrivia =
    NumberTriviaModel.fromJson(jsonDecode(readFixture('trivia.json')));

    test('Should send request to URL with JSON content header', () {
      //arrange
      serverRequestSuccess();
      //act
      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return a NumberTriviaModel when sever request successful',
            () async {
          //arrange
          serverRequestSuccess();
          //act
          final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
          //assert
          expect(result, tNumberTrivia);
        });

    test('Should return a ServerException when sever request unsuccessful', () {
      //arrange
      serverRequestError();
      //act
      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });
}
