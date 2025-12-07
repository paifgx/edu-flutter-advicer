import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'application/pages/advice/bloc/advice_bloc.dart';
import 'application/pages/advice/bloc/favorites/favorites_bloc.dart';
import 'domain/usecases/get_advice_usecase.dart';
import 'domain/usecases/get_favorites_usecase.dart';
import 'domain/usecases/remove_favorite_usecase.dart';
import 'domain/usecases/save_favorite_usecase.dart';
import 'infrastructure/datasources/advice_remote_data_source.dart';
import 'infrastructure/datasources/advice_local_data_source.dart';
import 'infrastructure/repositories/advice_repository_impl.dart';
import 'domain/repositories/advice_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // Externals
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Blocs
  sl.registerFactory(() => AdviceBloc(getAdviceUseCase: sl()));
  sl.registerFactory(() => FavoritesBloc(
        getFavoritesUseCase: sl(),
        saveFavoriteUseCase: sl(),
        removeFavoriteUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetAdviceUseCase(adviceRepository: sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(adviceRepository: sl()));
  sl.registerLazySingleton(() => SaveFavoriteUseCase(adviceRepository: sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(adviceRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AdviceRepository>(
    () => AdviceRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AdviceRemoteDataSource>(
    () => AdviceRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AdviceLocalDataSource>(
    () => AdviceLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

