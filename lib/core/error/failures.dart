import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => properties;
}

class ServerFailures extends Failure {}

class CacheFailures extends Failure {}
