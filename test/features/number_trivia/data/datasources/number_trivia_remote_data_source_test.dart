import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl();
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;

    test('Should return a NumberTriviaModel ', body)
  });
}