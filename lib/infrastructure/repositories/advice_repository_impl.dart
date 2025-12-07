import 'package:dartz/dartz.dart';

import '../../core/exceptions/exceptions.dart';
import '../../core/failures/failures.dart';
import '../../domain/entities/advice_entity.dart';
import '../../domain/repositories/advice_repository.dart';
import '../datasources/advice_remote_data_source.dart';
import '../datasources/advice_local_data_source.dart';
import '../models/advice_model.dart';

class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceRemoteDataSource remoteDataSource;
  final AdviceLocalDataSource localDataSource;

  AdviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromApi() async {
    try {
      final result = await remoteDataSource.getRandomAdviceFromApi();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, List<AdviceEntity>>> getFavoriteAdvices() async {
    try {
      final result = await localDataSource.getFavoriteAdvices();
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(CacheFailure('Unexpected cache error'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheFavoriteAdvice(AdviceEntity advice) async {
    try {
      await localDataSource.cacheFavoriteAdvice(
        AdviceModel(advice: advice.advice, id: advice.id),
      );
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(CacheFailure('Unexpected cache error'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteAdvice(int id) async {
    try {
      await localDataSource.removeFavoriteAdvice(id);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(CacheFailure('Unexpected cache error'));
    }
  }
}

