import 'package:get_it/get_it.dart';

import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/repository_impl.dart';
import '../../domain/repositories/repository.dart';

void registerRepositoryModule(GetIt sl, {bool forceLocal = false}) {
  sl.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      remoteDataSource: sl<RemoteDataSource>(),
      localDataSource: sl<LocalDataSource>(),
      forceLocal: forceLocal,
    ),
  );
}
