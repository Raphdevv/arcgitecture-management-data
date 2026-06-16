import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logger/core_log.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/remote_datasource.dart';

void registerRemoteModule(GetIt sl) {
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(shouldFail: false, logger: sl<AppLogger>()),
  );

  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sl<SharedPreferences>()),
  );
}
