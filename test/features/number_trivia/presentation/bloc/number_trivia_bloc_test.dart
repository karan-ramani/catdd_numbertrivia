import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:catdd_numbertrivia/core/usecases/usecase.dart';
import 'package:catdd_numbertrivia/core/utils/input_converter.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:catdd_numbertrivia/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:catdd_numbertrivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(InitialNumberTriviaState()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, trivia: 'test trivia');

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Right(tNumberParsed));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInt(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInt(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InputValidationFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          InitialNumberTriviaState(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
        'Should get data from the concrete use case'
        'and emit [Loading] [Loaded] in same order', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });

    test(
        'Should get data from the concrete use case'
        'and emit [Loading] [Error] ServerFailure in same order', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });

    test(
        'Should get data from the concrete use case'
        'and emit [Loading] [Error] CacheFailure in same order', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, trivia: 'test trivia');

    test(
        'Should get data from the random use case'
        'and emit [Loading] [Loaded] in same order', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'Should get data from the random use case'
        'and emit [Loading] [Error] ServerFailure in same order', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'Should get data from the random use case'
        'and emit [Loading] [Error] CacheFailure in same order', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
      //assert Later
      final expected = [
        InitialNumberTriviaState(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });
  });
}
