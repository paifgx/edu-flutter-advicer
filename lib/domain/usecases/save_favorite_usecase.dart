import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/advice_entity.dart';
import '../repositories/advice_repository.dart';

class SaveFavoriteUseCase {
  final AdviceRepository adviceRepository;

  SaveFavoriteUseCase({required this.adviceRepository});

  Future<Either<Failure, void>> call(AdviceEntity advice) async {
    return adviceRepository.cacheFavoriteAdvice(advice);
  }
}

