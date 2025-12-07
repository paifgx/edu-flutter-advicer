import 'package:advicer/domain/entities/advice_entity.dart';
import 'package:advicer/domain/repositories/advice_repository.dart';
import 'package:advicer/domain/usecases/get_advice_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceRepository extends Mock implements AdviceRepository {}

void main() {
  late MockAdviceRepository mockRepo;
  late GetAdviceUseCase useCase;

  setUp(() {
    mockRepo = MockAdviceRepository();
    useCase = GetAdviceUseCase(adviceRepository: mockRepo);
  });

  test('should return AdviceEntity from repository', () async {
    // arrange
    const tAdvice = AdviceEntity(advice: 'Test', id: 1);
    when(() => mockRepo.getAdviceFromApi())
        .thenAnswer((_) async => const Right(tAdvice));

    // act
    final result = await useCase();

    // assert
    expect(result, const Right(tAdvice));
    verify(() => mockRepo.getAdviceFromApi()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

