import 'package:advicer/domain/entities/advice_entity.dart';
import 'package:advicer/domain/repositories/advice_repository.dart';
import 'package:advicer/domain/usecases/save_favorite_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceRepository extends Mock implements AdviceRepository {}

void main() {
  late MockAdviceRepository mockRepo;
  late SaveFavoriteUseCase useCase;

  setUp(() {
    mockRepo = MockAdviceRepository();
    useCase = SaveFavoriteUseCase(adviceRepository: mockRepo);
  });

  test('should cache favorite advice via repository', () async {
    const advice = AdviceEntity(advice: 'Test', id: 1);
    when(() => mockRepo.cacheFavoriteAdvice(advice))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(advice);

    expect(result, const Right(null));
    verify(() => mockRepo.cacheFavoriteAdvice(advice)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

