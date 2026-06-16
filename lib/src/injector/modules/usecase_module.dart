import 'package:get_it/get_it.dart';

import '../../domain/repositories/architecture_management_repository.dart';
import '../../domain/usecases/architecture_management_usecases.dart';

void registerUseCaseModule(GetIt sl) {
  sl.registerLazySingleton(
    () => GetAllArchitectureManagementUseCase(
      sl<ArchitectureManagementRepository>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetArchitectureManagementByIdUseCase(
      sl<ArchitectureManagementRepository>(),
    ),
  );

  sl.registerLazySingleton(
    () => CreateArchitectureManagementUseCase(
      sl<ArchitectureManagementRepository>(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateArchitectureManagementUseCase(
      sl<ArchitectureManagementRepository>(),
    ),
  );

  sl.registerLazySingleton(
    () => DeleteArchitectureManagementUseCase(
      sl<ArchitectureManagementRepository>(),
    ),
  );
}
