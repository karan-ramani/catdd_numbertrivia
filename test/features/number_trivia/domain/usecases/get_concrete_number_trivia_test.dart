import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

main(){
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  
  int tNumber = 1;
  NumberTrivia tNumberTrivia;
  
  test('Should accept number and return Trivia', () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)
        .then((_){Right()})
    );
    //act
    
    //verify
    
  });
}
