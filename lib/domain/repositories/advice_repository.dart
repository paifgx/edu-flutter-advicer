import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/advice_entity.dart';

abstract class AdviceRepository {
  Future<Either<Failure, AdviceEntity>> getAdviceFromApi();
}

