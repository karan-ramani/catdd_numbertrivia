import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NumberTrivia extends Equatable {
  final String trivia;
  final int number;

  NumberTrivia({@required this.number, @required this.trivia});

  @override
  List<Object> get props => [number, trivia];
}
