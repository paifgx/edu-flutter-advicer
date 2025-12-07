import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/advice_entity.dart';
import '../repositories/advice_repository.dart';

class GetAdviceUseCase {
  final AdviceRepository adviceRepository;

  GetAdviceUseCase({required this.adviceRepository});

  Future<Either<Failure, AdviceEntity>> call() async {
    return adviceRepository.getAdviceFromApi();
  }
}

