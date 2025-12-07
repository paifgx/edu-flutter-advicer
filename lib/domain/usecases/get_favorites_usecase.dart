import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/advice_entity.dart';
import '../repositories/advice_repository.dart';

class GetFavoritesUseCase {
  final AdviceRepository adviceRepository;

  GetFavoritesUseCase({required this.adviceRepository});

  Future<Either<Failure, List<AdviceEntity>>> call() async {
    return adviceRepository.getFavoriteAdvices();
  }
}

