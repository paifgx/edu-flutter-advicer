import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../../domain/entities/advice_entity.dart';

abstract class AdviceRepository {
  Future<Either<Failure, AdviceEntity>> getAdviceFromApi();
}
