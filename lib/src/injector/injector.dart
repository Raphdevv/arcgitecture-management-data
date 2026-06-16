import 'package:architecture_management_data/src/injector/modules/modules.dart';
import 'package:get_it/get_it.dart';

final GetIt architectureManagementSl = GetIt.asNewInstance();

/// [forceLocal] = true → ข้าม remote ทุก call ใช้ local เท่านั้น
/// ใช้ตอน dev หรือ test โดยไม่ต้องการ API จริง
Future<void> setupArchitectureManagementInjector({
  GetIt? sl,
  bool forceLocal = false,
}) async {
  final serviceLocator = sl ?? architectureManagementSl;

  await registerSharedPreferencesModule(serviceLocator);
  registerRemoteModule(serviceLocator);
  registerRepositoryModule(serviceLocator, forceLocal: forceLocal);
  registerUseCaseModule(serviceLocator);
}
