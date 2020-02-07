import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String numberString) {
    int number;
    try {
      number = int.parse(numberString);
      if (number < 0) throw FormatException();
    } on FormatException {
      return Left(InputValidationFailure());
    }
    return Right(number);
  }
}

class InputValidationFailure extends Failure {}
