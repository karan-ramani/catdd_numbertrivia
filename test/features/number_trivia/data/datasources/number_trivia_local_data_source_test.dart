import 'dart:convert';

import 'package:catdd_numbertrivia/core/error/exceptions.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MocKSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSourceImpl;
  MocKSharedPreferences mocKSharedPreferences;

  setUp(() {
    mocKSharedPreferences = MocKSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mocKSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(readFixture('trivia_cached.json')));

    test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mocKSharedPreferences.getString(any))
          .thenReturn(readFixture('trivia_cached.json'));
      // act
      final result = await dataSourceImpl.getLastNumberTrivia();
      // assert
      verify(mocKSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return Cache Execption when no data is present', () async {
      // arrange
      when(mocKSharedPreferences.getString(any)).thenReturn(null);
      // act
      try {
        dataSourceImpl.getLastNumberTrivia();
      } on Exception catch (e) {
        // assert
        expect(e, isInstanceOf<CacheException>());
      }
      verify(mocKSharedPreferences.getString(any));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTrivia = NumberTriviaModel(number: 1, trivia: 'test text');

    test('should call sharedpreferences setstrings to cache data', () {
      //arrange
      final expectedJsonString = jsonEncode(tNumberTrivia.toJson());
      //act
      dataSourceImpl.cacheNumberTrivia(tNumberTrivia);
      //assert
      verify(mocKSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
