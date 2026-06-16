import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/architecture_management_local_datasource.dart';
import '../../data/datasources/remote/architecture_management_remote_datasource.dart';

void registerRemoteModule(GetIt sl) {
  // Remote Data Source
  sl.registerLazySingleton<ArchitectureManagementRemoteDataSource>(
    () => ArchitectureManagementRemoteDataSourceImpl(shouldFail: false),
  );

  // Local Data Source — inject SharedPreferences จาก sl
  sl.registerLazySingleton<ArchitectureManagementLocalDataSource>(
    () => ArchitectureManagementLocalDataSourceImpl(sl<SharedPreferences>()),
  );
}
