import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failures/failures.dart';
import '../../../../domain/usecases/get_advice_usecase.dart';
import 'advice_event.dart';
import 'advice_state.dart';

class AdviceBloc extends Bloc<AdviceEvent, AdviceState> {
  final GetAdviceUseCase getAdviceUseCase;

  AdviceBloc({required this.getAdviceUseCase}) : super(const AdviceInitial()) {
    on<AdviceRequestedEvent>(_onAdviceRequested);
  }

  Future<void> _onAdviceRequested(
    AdviceRequestedEvent event,
    Emitter<AdviceState> emit,
  ) async {
    emit(const AdviceLoading());

    final failureOrAdvice = await getAdviceUseCase();

    failureOrAdvice.fold(
      (failure) => emit(AdviceError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdviceLoaded(advice: advice.advice)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Serverfehler. Bitte versuche es später erneut.';
      case CacheFailure:
        return 'Cachefehler. Bitte versuche es erneut.';
      default:
        return 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }
}
