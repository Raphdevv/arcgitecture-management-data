import 'package:architecture_management_data/src/domain/usecases/params/note_params.dart';

/// Params สำหรับ [MergeNoteUsecase]
///
/// [content] ต้องมีอย่างน้อย 2 ตัว — index 0 และ 1 จะถูก merge
///
/// Example:
/// ```dart
/// await mergeNoteUsecase(
///   params: MergeNoteParams(
///     content: [
///       UpdateNoteParams(id: 'id-a', name: 'Note A', description: 'Desc A'),
///       UpdateNoteParams(id: 'id-b', name: 'Note B', description: 'Desc B'),
///     ],
///   ),
/// );
/// // → สร้าง note ใหม่ชื่อ 'Note A and Note B'
/// // → ลบ 'id-a' และ 'id-b'
/// ```
class MergeNoteParams {
  /// Note ทั้งสองที่ต้องการ merge (ต้องมี 2 ตัว)
  final List<UpdateNoteParams> content;

  MergeNoteParams({required this.content});
}
