import 'package:catdd_numbertrivia/core/platform/network_info.dart';
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
      test(
          'Should get entity NumberTrivia with data when remoteDataSoure call is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await
            numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(
                mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                    tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          'Should cache the data locally when remoteDataSoure call is successful', () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber));
        verify(
            mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTrivia));
      });
    });
  });
}
