import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/advice_entity.dart';

abstract class AdviceRepository {
  Future<Either<Failure, AdviceEntity>> getAdviceFromApi();
  Future<Either<Failure, List<AdviceEntity>>> getFavoriteAdvices();
  Future<Either<Failure, void>> cacheFavoriteAdvice(AdviceEntity advice);
  Future<Either<Failure, void>> removeFavoriteAdvice(int id);
}

