import 'package:get_it/get_it.dart';

import 'modules/remote_module.dart';
import 'modules/repository_module.dart';
import 'modules/shared_preferences_module.dart';
import 'modules/usecase_module.dart';

final GetIt architectureManagementSl = GetIt.asNewInstance();
Future<void> setupArchitectureManagementInjector({GetIt? sl}) async {
  final serviceLocator = sl ?? architectureManagementSl;

  await registerSharedPreferencesModule(serviceLocator);
  registerRemoteModule(serviceLocator);
  registerRepositoryModule(serviceLocator);
  registerUseCaseModule(serviceLocator);
}
