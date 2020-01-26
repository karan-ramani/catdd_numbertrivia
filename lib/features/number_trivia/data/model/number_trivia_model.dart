import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/foundation.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required int number,
    @required String trivia,
  }) : super(
          number: number,
          trivia: trivia,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) {
    return NumberTriviaModel(
        number: (jsonMap['number'] as num).toInt(),
        trivia: jsonMap['text'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': trivia,
    };
  }
}
