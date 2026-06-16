import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/remote_datasource.dart';

void registerRemoteModule(GetIt sl) {
  // Remote Data Source
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(shouldFail: false),
  );

  // Local Data Source — inject SharedPreferences จาก sl
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sl<SharedPreferences>()),
  );
}
