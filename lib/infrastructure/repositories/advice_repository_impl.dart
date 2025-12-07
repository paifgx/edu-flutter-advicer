import 'package:dartz/dartz.dart';

import '../../core/exceptions/exceptions.dart';
import '../../core/failures/failures.dart';
import '../../domain/entities/advice_entity.dart';
import '../../domain/repositories/advice_repository.dart';
import '../datasources/advice_remote_data_source.dart';

class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceRemoteDataSource remoteDataSource;

  AdviceRepositoryImpl({required this.remoteDataSource});

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
}

