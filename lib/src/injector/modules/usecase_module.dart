import 'package:get_it/get_it.dart';

import '../../domain/repositories/repository.dart';
import '../../domain/usecases/note_usecases.dart';
import '../../domain/utils/id_generator.dart';

void registerUseCaseModule(GetIt sl) {
  // register IdGenerator
  sl.registerLazySingleton<IdGenerator>(() => const UuidIdGenerator());

  sl.registerLazySingleton(
    () => GetAllNoteUseCase(
      sl<Repository>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetNoteByIdUseCase(
      sl<Repository>(),
    ),
  );

  sl.registerLazySingleton(
    () => CreateNoteUseCase(
      sl<Repository>(),
      sl<IdGenerator>(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateNoteUseCase(
      sl<Repository>(),
    ),
  );

  sl.registerLazySingleton(
    () => DeleteNoteUseCase(
      sl<Repository>(),
    ),
  );
}
