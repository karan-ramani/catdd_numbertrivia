import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catdd_numbertrivia/core/utils/input_converter.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({@required GetConcreteNumberTrivia concrete,
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
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event,) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
      inputConverter.stringToUnsignedInt(event.numberString);

      yield* inputEither.fold(
            (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
            (integer) => throw UnimplementedError(),
      );
    }
  }
}