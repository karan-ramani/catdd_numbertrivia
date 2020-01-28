import 'package:catdd_numbertrivia/core/platform/network_info.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}
class MockNumberTriviaLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

  mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
  mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
  mockNetworkInfo = MockNetworkInfo();

  numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
    remoteDataSource: mockNumberTriviaRemoteDataSource,
    localDataSource: mockNumberTriviaLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  test('NumberTriviaRepositoryImpl should implement NumberTriviaRepository', (){
    expect(numberTriviaRepositoryImpl, isA<NumberTriviaRepository>());
  });
}
