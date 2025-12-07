import 'package:advicer/application/pages/advice/bloc/favorites/favorites_bloc.dart';
import 'package:advicer/application/pages/advice/bloc/favorites/favorites_event.dart';
import 'package:advicer/application/pages/advice/bloc/favorites/favorites_state.dart';
import 'package:advicer/core/failures/failures.dart';
import 'package:advicer/domain/entities/advice_entity.dart';
import 'package:advicer/domain/usecases/get_favorites_usecase.dart';
import 'package:advicer/domain/usecases/remove_favorite_usecase.dart';
import 'package:advicer/domain/usecases/save_favorite_usecase.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockSaveFavoriteUseCase extends Mock implements SaveFavoriteUseCase {}

class MockRemoveFavoriteUseCase extends Mock implements RemoveFavoriteUseCase {}

void main() {
  late MockGetFavoritesUseCase mockGetFavorites;
  late MockSaveFavoriteUseCase mockSaveFavorite;
  late MockRemoveFavoriteUseCase mockRemoveFavorite;

  setUp(() {
    mockGetFavorites = MockGetFavoritesUseCase();
    mockSaveFavorite = MockSaveFavoriteUseCase();
    mockRemoveFavorite = MockRemoveFavoriteUseCase();
  });

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [Loading, Loaded] on load success',
    build: () {
      when(() => mockGetFavorites())
          .thenAnswer((_) async => const Right([AdviceEntity(advice: 'A', id: 1)]));
      return FavoritesBloc(
        getFavoritesUseCase: mockGetFavorites,
        saveFavoriteUseCase: mockSaveFavorite,
        removeFavoriteUseCase: mockRemoveFavorite,
      );
    },
    act: (bloc) => bloc.add(const LoadFavoritesEvent()),
    expect: () => [
      const FavoritesLoading(),
      const FavoritesLoaded(favorites: [AdviceEntity(advice: 'A', id: 1)]),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [Loading, Error] on load failure',
    build: () {
      when(() => mockGetFavorites())
          .thenAnswer((_) async => const Left(CacheFailure()));
      return FavoritesBloc(
        getFavoritesUseCase: mockGetFavorites,
        saveFavoriteUseCase: mockSaveFavorite,
        removeFavoriteUseCase: mockRemoveFavorite,
      );
    },
    act: (bloc) => bloc.add(const LoadFavoritesEvent()),
    expect: () => [
      const FavoritesLoading(),
      const FavoritesError(message: 'Lokaler Speicherfehler.'),
    ],
  );
}

