import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:dartz/dartz.dart';

/// Contract ของ Note Repository สำหรับ Domain layer
///
/// Domain ไม่รู้ว่าข้อมูลมาจาก Remote หรือ Local
/// Implementation จริงอยู่ใน [RepositoryImpl]
abstract class Repository {
  /// ดึง note ทั้งหมด
  ///
  /// Returns:
  /// - `Right(List<NoteManagementEntity>)` — list ของ note ทั้งหมด
  /// - `Left(Failure)` — error จาก datasource
  Future<Either<Failure, List<NoteManagementEntity>>> getAll();

  /// ดึง note ตาม [id]
  ///
  /// Returns:
  /// - `Right(NoteManagementEntity)` — note ที่ตรงกับ id
  /// - `Left(NotFoundFailure)` — ไม่พบ note
  /// - `Left(Failure)` — error อื่นๆ
  Future<Either<Failure, NoteManagementEntity>> getById(String id);

  /// สร้าง note ใหม่
  ///
  /// [entity] ควรถูกสร้างจาก [CreateNoteUseCase] เพื่อให้ id และ createdAt
  /// ถูก generate อย่างถูกต้อง
  ///
  /// Returns:
  /// - `Right(NoteManagementEntity)` — note ที่สร้างสำเร็จ
  /// - `Left(Failure)` — error จาก datasource
  Future<Either<Failure, NoteManagementEntity>> create(
    NoteManagementEntity entity,
  );

  /// อัปเดต note ที่มีอยู่
  ///
  /// Returns:
  /// - `Right(NoteManagementEntity)` — note ที่อัปเดตแล้ว
  /// - `Left(NotFoundFailure)` — ไม่พบ note ที่ต้องการอัปเดต
  /// - `Left(Failure)` — error อื่นๆ
  Future<Either<Failure, NoteManagementEntity>> update(
    NoteManagementEntity entity,
  );

  /// ลบ note ตาม [id]
  ///
  /// Returns:
  /// - `Right(void)` — ลบสำเร็จ
  /// - `Left(Failure)` — error จาก datasource
  Future<Either<Failure, void>> delete(String id);
}
