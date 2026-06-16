import 'package:get_it/get_it.dart';

import '../../data/datasources/local/architecture_management_local_datasource.dart';
import '../../data/datasources/remote/architecture_management_remote_datasource.dart';
import '../../data/repositories/architecture_management_repository_impl.dart';
import '../../domain/repositories/architecture_management_repository.dart';

void registerRepositoryModule(GetIt sl) {
  sl.registerLazySingleton<ArchitectureManagementRepository>(
    () => ArchitectureManagementRepositoryImpl(
      remoteDataSource: sl<ArchitectureManagementRemoteDataSource>(),
      localDataSource: sl<ArchitectureManagementLocalDataSource>(),
    ),
  );
}
