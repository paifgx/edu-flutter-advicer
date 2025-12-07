import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'application/pages/advice/bloc/advice_bloc.dart';
import 'domain/usecases/get_advice_usecase.dart';
import 'infrastructure/datasources/advice_remote_data_source.dart';
import 'infrastructure/repositories/advice_repository_impl.dart';
import 'domain/repositories/advice_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Externals
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Blocs
  sl.registerFactory(() => AdviceBloc(getAdviceUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAdviceUseCase(adviceRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AdviceRepository>(
    () => AdviceRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AdviceRemoteDataSource>(
    () => AdviceRemoteDataSourceImpl(client: sl()),
  );
}

