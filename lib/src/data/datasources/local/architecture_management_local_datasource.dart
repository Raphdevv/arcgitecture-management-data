import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/architecture_management_model.dart';

abstract class ArchitectureManagementLocalDataSource {
  Future<List<ArchitectureManagementModel>> getCachedAll();
  Future<ArchitectureManagementModel?> getCachedById(String id);
  Future<void> cacheAll(List<ArchitectureManagementModel> models);
  Future<void> cacheOne(ArchitectureManagementModel model);
  Future<void> removeById(String id);
  Future<void> clearAll();
}

class ArchitectureManagementLocalDataSourceImpl
    implements ArchitectureManagementLocalDataSource {
  final SharedPreferences _prefs;

  const ArchitectureManagementLocalDataSourceImpl(this._prefs);

  static const String _cacheKey = 'architecture_management_cache';

  @override
  Future<List<ArchitectureManagementModel>> getCachedAll() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return [];
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map(
          (e) =>
              ArchitectureManagementModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<ArchitectureManagementModel?> getCachedById(String id) async {
    final all = await getCachedAll();
    try {
      return all.firstWhere((model) => model.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> cacheAll(List<ArchitectureManagementModel> models) async {
    final jsonString = json.encode(
      models.map((model) => model.toJson()).toList(),
    );
    await _prefs.setString(_cacheKey, jsonString);
  }

  @override
  Future<void> cacheOne(ArchitectureManagementModel model) async {
    final all = await getCachedAll();
    final index = all.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      all[index] = model;
    } else {
      all.add(model);
    }
    await cacheAll(all);
  }

  @override
  Future<void> removeById(String id) async {
    final all = await getCachedAll();
    all.removeWhere((model) => model.id == id);
    await cacheAll(all);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_cacheKey);
  }
}
