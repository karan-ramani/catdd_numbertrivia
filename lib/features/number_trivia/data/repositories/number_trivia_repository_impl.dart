import 'package:catdd_numbertrivia/core/error/failures.dart';
import 'package:catdd_numbertrivia/core/platform/network_info.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:catdd_numbertrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
    await localDataSource.cacheNumberTrivia(remoteTrivia);
    return Right(remoteTrivia);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return null;
  }
}
