import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerSharedPreferencesModule(GetIt sl) async {
  sl.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
}
