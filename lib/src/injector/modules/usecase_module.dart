import 'package:architecture_management_data/src/core/logger/core_log.dart';
import 'package:architecture_management_data/src/domain/domain.dart';
import 'package:get_it/get_it.dart';

void registerUseCaseModule(GetIt sl) {
  // register IdGenerator
  sl.registerLazySingleton<IdGenerator>(() => const UuidIdGenerator());

  sl.registerLazySingleton(() => GetAllNoteUseCase(sl<Repository>()));

  sl.registerLazySingleton(() => GetNoteByIdUseCase(sl<Repository>()));

  sl.registerLazySingleton(
    () => CreateNoteUseCase(sl<Repository>(), sl<IdGenerator>()),
  );

  sl.registerLazySingleton(() => UpdateNoteUseCase(sl<Repository>()));

  sl.registerLazySingleton(() => DeleteNoteUseCase(sl<Repository>()));

  // Register MergeNoteUsecase (depends on Create + Delete already registered)
  sl.registerLazySingleton(
    () => MergeNoteUsecase(
      createNoteUseCase: sl<CreateNoteUseCase>(),
      deleteNoteUseCase: sl<DeleteNoteUseCase>(),
      logger: sl<AppLogger>(),
    ),
  );
}
