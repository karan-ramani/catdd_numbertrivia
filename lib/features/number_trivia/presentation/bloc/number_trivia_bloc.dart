import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:catdd_numbertrivia/core/usecases/usecase.dart';
import 'package:catdd_numbertrivia/core/utils/input_converter.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => InitialNumberTriviaState();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
            (int integer) async* {
          yield Loading();
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> either,) async* {
    yield either.fold(
          (failure) => _mapToError(failure),
          (trivia) {
        print(trivia.trivia);
        return Loaded(trivia: trivia);
      },
    );
  }

  Error _mapToError(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Error(message: SERVER_FAILURE_MESSAGE);
      case CacheFailure:
        return Error(message: CACHE_FAILURE_MESSAGE);
      default:
        return Error(message: 'Unexpected Error');
    }
  }
}
