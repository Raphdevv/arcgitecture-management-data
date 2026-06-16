import 'package:architecture_management_data/src/core/logger/core_log.dart';
import 'package:architecture_management_data/src/domain/entities/note_management_entity.dart';
import 'package:architecture_management_data/src/domain/repositories/repository.dart';
import 'package:architecture_management_data/src/domain/utils/id_generator.dart';
import 'package:mocktail/mocktail.dart';

/// Logger ที่ใช้ใน test — inject แทน [CoreLog] เพื่อไม่ให้ log รบกวน output
const testLogger = SilentLog();

class MockRepository extends Mock implements Repository {}

class MockIdGenerator extends Mock implements IdGenerator {}

/// เรียกใน [setUpAll] ของทุก test file ที่ใช้ mock เหล่านี้
///
/// mocktail ต้องการ fallback value สำหรับ custom class
/// เมื่อใช้ [any()] หรือ [captureAny()] เป็น argument
void registerFallbackValues() {
  registerFallbackValue(
    NoteManagementEntity(
      id: '',
      name: '',
      description: '',
      createdAt: DateTime(2026),
    ),
  );
}
