import 'package:advicer/application/pages/advice/bloc/advice_bloc.dart';
import 'package:advicer/application/pages/advice/bloc/advice_event.dart';
import 'package:advicer/application/pages/advice/bloc/advice_state.dart';
import 'package:advicer/core/failures/failures.dart';
import 'package:advicer/domain/entities/advice_entity.dart';
import 'package:advicer/domain/usecases/get_advice_usecase.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAdviceUseCase extends Mock implements GetAdviceUseCase {}

void main() {
  late MockGetAdviceUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetAdviceUseCase();
  });

  blocTest<AdviceBloc, AdviceState>(
    'emits [Loading, Loaded] when usecase returns advice',
    build: () {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Right(AdviceEntity(advice: 'Test', id: 1)));
      return AdviceBloc(getAdviceUseCase: mockUseCase);
    },
    act: (bloc) => bloc.add(const AdviceRequestedEvent()),
    expect: () => [
      const AdviceLoading(),
      const AdviceLoaded(advice: 'Test'),
    ],
    verify: (_) {
      verify(() => mockUseCase()).called(1);
    },
  );

  blocTest<AdviceBloc, AdviceState>(
    'emits [Loading, Error] when usecase returns failure',
    build: () {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Left(ServerFailure()));
      return AdviceBloc(getAdviceUseCase: mockUseCase);
    },
    act: (bloc) => bloc.add(const AdviceRequestedEvent()),
    expect: () => [
      const AdviceLoading(),
      const AdviceError(message: 'Serverfehler. Bitte versuche es später erneut.'),
    ],
  );
}

