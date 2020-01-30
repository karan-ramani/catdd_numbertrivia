import 'package:catdd_numbertrivia/core/error/exceptions.dart';
import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:catdd_numbertrivia/core/network/network_info.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, trivia: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should get entity NumberTrivia with data when remoteDataSoure call is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                    tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          'Should cache the data locally when remoteDataSoure call is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(
                mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTrivia));
          });

      test(
          'Should get ServerException when remoteDataSoure call is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                tNumber))
                .thenThrow(ServerException());
            //act
            final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                    tNumber));
            verifyZeroInteractions(mockNumberTriviaLocalDataSource);
            expect(result, Left(ServerFailure()));
          });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'Should get entity NumberTrivia with data when device is offline - '
              'localDataSoure call is successful - Cached data is present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test('Should get CacheException when localDataSoure call is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            expect(result, Left(CacheFailure()));
          });
    });
  });

  group('getRandomNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 14234; //Random
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, trivia: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      numberTriviaRepositoryImpl.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should get entity NumberTrivia with data when remoteDataSoure call is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await numberTriviaRepositoryImpl
                .getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          'Should cache the data locally when remoteDataSoure call is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            await numberTriviaRepositoryImpl.getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            verify(
                mockNumberTriviaLocalDataSource.cacheNumberTrivia(
                    tNumberTrivia));
          });

      test(
          'Should get ServerException when remoteDataSoure call is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            //act
            final result = await numberTriviaRepositoryImpl
                .getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockNumberTriviaLocalDataSource);
            expect(result, Left(ServerFailure()));
          });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'Should get entity NumberTrivia with data when device is offline - '
              'localDataSoure call is successful - Cached data is present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await numberTriviaRepositoryImpl
                .getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test('Should get CacheException when localDataSoure call is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await numberTriviaRepositoryImpl
                .getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            expect(result, Left(CacheFailure()));
          });
    });
  });
}
