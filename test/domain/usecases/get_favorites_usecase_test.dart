import 'package:advicer/domain/entities/advice_entity.dart';
import 'package:advicer/domain/repositories/advice_repository.dart';
import 'package:advicer/domain/usecases/get_favorites_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceRepository extends Mock implements AdviceRepository {}

void main() {
  late MockAdviceRepository mockRepo;
  late GetFavoritesUseCase useCase;

  setUp(() {
    mockRepo = MockAdviceRepository();
    useCase = GetFavoritesUseCase(adviceRepository: mockRepo);
  });

  test('should return list of favorites from repository', () async {
    const favorites = [
      AdviceEntity(advice: 'A', id: 1),
      AdviceEntity(advice: 'B', id: 2),
    ];
    when(() => mockRepo.getFavoriteAdvices())
        .thenAnswer((_) async => const Right(favorites));

    final result = await useCase();

    expect(result, const Right(favorites));
    verify(() => mockRepo.getFavoriteAdvices()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

