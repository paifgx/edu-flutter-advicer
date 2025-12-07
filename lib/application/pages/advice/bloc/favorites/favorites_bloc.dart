import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../domain/usecases/get_favorites_usecase.dart';
import '../../../../../domain/usecases/remove_favorite_usecase.dart';
import '../../../../../domain/usecases/save_favorite_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final SaveFavoriteUseCase saveFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.saveFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());
    final result = await getFavoritesUseCase();
    result.fold(
      (failure) => emit(FavoritesError(message: _mapFailure(failure))),
      (data) => emit(FavoritesLoaded(favorites: data)),
    );
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final current = state is FavoritesLoaded
        ? (state as FavoritesLoaded).favorites
        : const [];
    final result = await saveFavoriteUseCase(event.advice);
    result.fold(
      (failure) => emit(FavoritesError(message: _mapFailure(failure))),
      (_) async {
        // reload list to reflect updated state
        emit(const FavoritesLoading());
        final refreshed = await getFavoritesUseCase();
        refreshed.fold(
          (failure) => emit(FavoritesError(message: _mapFailure(failure))),
          (data) => emit(FavoritesLoaded(favorites: data)),
        );
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFavoriteUseCase(event.id);
    result.fold(
      (failure) => emit(FavoritesError(message: _mapFailure(failure))),
      (_) async {
        emit(const FavoritesLoading());
        final refreshed = await getFavoritesUseCase();
        refreshed.fold(
          (failure) => emit(FavoritesError(message: _mapFailure(failure))),
          (data) => emit(FavoritesLoaded(favorites: data)),
        );
      },
    );
  }

  String _mapFailure(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Lokaler Speicherfehler.';
      case ServerFailure:
        return 'Serverfehler.';
      default:
        return 'Unbekannter Fehler.';
    }
  }
}

