import 'package:catdd_numbertrivia/core/usecase/usecase.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  NumberTrivia tNumberTrivia = NumberTrivia(number: 1, trivia: 'test');

  test('Should return a NumberTrivia without any number param', () async {
  //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

  //act
    final result = await useCase(NoParams());

  //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
