import 'package:advicer/domain/repositories/advice_repository.dart';
import 'package:advicer/domain/usecases/remove_favorite_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceRepository extends Mock implements AdviceRepository {}

void main() {
  late MockAdviceRepository mockRepo;
  late RemoveFavoriteUseCase useCase;

  setUp(() {
    mockRepo = MockAdviceRepository();
    useCase = RemoveFavoriteUseCase(adviceRepository: mockRepo);
  });

  test('should remove favorite by id via repository', () async {
    when(() => mockRepo.removeFavoriteAdvice(1))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(1);

    expect(result, const Right(null));
    verify(() => mockRepo.removeFavoriteAdvice(1)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

