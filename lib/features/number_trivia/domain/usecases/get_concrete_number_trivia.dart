import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:catdd_numbertrivia/core/usecases/usecase.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
