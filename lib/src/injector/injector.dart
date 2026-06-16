import 'package:architecture_management_data/src/core/logger/core_log.dart';
import 'package:architecture_management_data/src/injector/modules/modules.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final GetIt architectureManagementSl = GetIt.asNewInstance();

/// [forceLocal] = true → ข้าม remote ทุก call ใช้ local เท่านั้น
/// [logger] = inject logger เอง หรือ default เป็น [CoreLog] ที่ปรับตาม build mode
Future<void> setupArchitectureManagementInjector({
  GetIt? sl,
  bool forceLocal = false,
  AppLogger? logger,
}) async {
  final serviceLocator = sl ?? architectureManagementSl;

  serviceLocator.registerSingleton<AppLogger>(
    logger ?? CoreLog(minLevel: kReleaseMode ? LogLevel.error : LogLevel.debug),
  );

  await registerSharedPreferencesModule(serviceLocator);
  registerRemoteModule(serviceLocator);
  registerRepositoryModule(serviceLocator, forceLocal: forceLocal);
  registerUseCaseModule(serviceLocator);
}
