import 'package:uuid/uuid.dart';

/// Interface สำหรับ generate unique ID
///
/// Inject เข้า [CreateNoteUseCase] เพื่อให้ test mock ได้ง่าย
abstract class IdGenerator {
  /// Generate และคืน unique ID ใหม่
  String generate();
}

/// Generate UUID v4 แบบ random — ใช้ใน production
///
/// Example output: `'550e8400-e29b-41d4-a716-446655440000'`
class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  @override
  String generate() => const Uuid().v4();
}

/// Generate ID แบบ sequential (1, 2, 3...) — ใช้ใน test
///
/// ทำให้ผลลัพธ์คาดเดาได้ ง่ายต่อการ assert ใน unit test
///
/// Example:
/// ```dart
/// final gen = SequentialIdGenerator();
/// gen.generate(); // '1'
/// gen.generate(); // '2'
/// ```
class SequentialIdGenerator implements IdGenerator {
  int _counter;

  SequentialIdGenerator({int start = 0}) : _counter = start;

  @override
  String generate() => (++_counter).toString();
}
