import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../repositories/advice_repository.dart';

class RemoveFavoriteUseCase {
  final AdviceRepository adviceRepository;

  RemoveFavoriteUseCase({required this.adviceRepository});

  Future<Either<Failure, void>> call(int id) async {
    return adviceRepository.removeFavoriteAdvice(id);
  }
}

