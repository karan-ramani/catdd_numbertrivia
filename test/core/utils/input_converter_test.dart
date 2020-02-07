import 'package:catdd_numbertrivia/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputConvertor - stringToUnsignedInt', () {
    final inputConverter = InputConverter();

    test('Should return integer value when number is provided as string', () {
      //act
      final result = inputConverter.stringToUnsignedInt('1');
      //assert
      expect(result, Right(1));
    });

    test(
        'Should return InputValidation Failure when negetive number is provided as string',
        () {
      //act
      final result = inputConverter.stringToUnsignedInt('-1');
      //assert
      expect(result, Left(InputValidationFailure()));
    });

    test(
        'Should return InputValidation Failure when nonnumeric value is provided as string',
        () {
      //act
      final result = inputConverter.stringToUnsignedInt('abc');
      //assert
      expect(result, Left(InputValidationFailure()));
    });
  });
}
