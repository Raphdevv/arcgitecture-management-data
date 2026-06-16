// Params — Domain Layer
// Presentation ส่ง Params เข้า UseCase แทนที่จะสร้าง Entity เอง
// - Presentation รู้แค่ field ที่ต้อง input
// - Business rule เช่น id, createdAt สร้างใน UseCase

/// Params สำหรับ Create — รับแค่ข้อมูลที่ user กรอก
class CreateNoteParams {
  final String name;
  final String description;

  const CreateNoteParams({required this.name, required this.description});
}

/// Params สำหรับ Update — ต้องรู้ id เพื่ออัปเดต record ที่ถูกต้อง
class UpdateNoteParams {
  final String id;
  final String name;
  final String description;

  const UpdateNoteParams({
    required this.id,
    required this.name,
    required this.description,
  });
}
