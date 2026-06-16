import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/note_management_model.dart';

/// Contract สำหรับ Local Data Source (Offline Cache)
///
/// ทำหน้าที่ cache ข้อมูลจาก remote ไว้ใน local storage
/// Repository จะ fallback มาที่นี่เมื่อ remote ล้มเหลว
abstract class LocalDataSource {
  Future<List<NoteManagementModel>> getCachedAll();
  Future<NoteManagementModel?> getCachedById(String id);
  Future<void> cacheAll(List<NoteManagementModel> models);
  Future<void> cacheOne(NoteManagementModel model);
  Future<void> removeById(String id);
  Future<void> clearAll();
}

/// Implementation ของ [LocalDataSource] โดยใช้ [SharedPreferences]
///
/// เก็บข้อมูลเป็น JSON string ภายใต้ key `note_management_cache`
///
/// **หมายเหตุ:** [removeById] และ [cacheOne] ทำ read-modify-write
/// ห้ามเรียกหลาย call พร้อมกัน (parallel) เพราะจะเกิด race condition
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _prefs;

  const LocalDataSourceImpl(this._prefs);

  static const String _cacheKey = 'note_management_cache';

  @override
  Future<List<NoteManagementModel>> getCachedAll() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return [];
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => NoteManagementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NoteManagementModel?> getCachedById(String id) async {
    final all = await getCachedAll();
    try {
      return all.firstWhere((model) => model.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> cacheAll(List<NoteManagementModel> models) async {
    final jsonString = json.encode(
      models.map((model) => model.toJson()).toList(),
    );
    await _prefs.setString(_cacheKey, jsonString);
  }

  @override
  Future<void> cacheOne(NoteManagementModel model) async {
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
