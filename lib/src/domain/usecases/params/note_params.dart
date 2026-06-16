// Params — Domain Layer
// Presentation ส่ง Params เข้า UseCase แทนที่จะสร้าง Entity เอง
// - Presentation รู้แค่ field ที่ต้อง input
// - Business rule เช่น id, createdAt สร้างใน UseCase

/// Params สำหรับ [CreateNoteUseCase]
///
/// Presentation ส่ง params นี้เข้า usecase
/// UseCase จะ generate [id] และ [createdAt] เอง
///
/// Example:
/// ```dart
/// await createNoteUseCase(CreateNoteParams(
///   name: 'Flutter Tips',
///   description: 'รวม tips การใช้ Flutter',
/// ));
/// ```
class CreateNoteParams {
  /// ชื่อของ note
  final String name;

  /// รายละเอียดของ note
  final String description;

  const CreateNoteParams({required this.name, required this.description});
}

/// Params สำหรับ [UpdateNoteUseCase]
///
/// ต้องระบุ [id] เพื่อให้ repository อัปเดต record ที่ถูกต้อง
///
/// Example:
/// ```dart
/// await updateNoteUseCase(UpdateNoteParams(
///   id: 'existing-uuid',
///   name: 'Updated Name',
///   description: 'Updated description',
/// ));
/// ```
class UpdateNoteParams {
  /// ID ของ note ที่ต้องการอัปเดต
  final String id;

  /// ชื่อใหม่
  final String name;

  /// รายละเอียดใหม่
  final String description;

  const UpdateNoteParams({
    required this.id,
    required this.name,
    required this.description,
  });
}
