import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:architecture_management_data/src/domain/repositories/repository.dart';
import 'package:architecture_management_data/src/domain/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'params/note_params.dart';

/// ดึง note ทั้งหมด
///
/// **Params:** ไม่มี
///
/// **Returns:**
/// - `Right(List<NoteManagementEntity>)` — list ของ note ทั้งหมด
/// - `Left(Failure)` — network/server/parse error
///
/// **Example:**
/// ```dart
/// final result = await getAllNoteUseCase();
/// result.fold(
///   (failure) => showError(failure.message),
///   (notes)   => showList(notes),
/// );
/// ```
class GetAllNoteUseCase {
  final Repository _repository;

  const GetAllNoteUseCase(this._repository);

  Future<Either<Failure, List<NoteManagementEntity>>> call() {
    return _repository.getAll();
  }
}

/// ดึง note ตาม ID
///
/// **Params:** [id] — UUID ของ note
///
/// **Returns:**
/// - `Right(NoteManagementEntity)` — note ที่ตรงกับ id
/// - `Left(NotFoundFailure)` — ไม่พบ note
/// - `Left(Failure)` — error อื่นๆ
class GetNoteByIdUseCase {
  final Repository _repository;

  const GetNoteByIdUseCase(this._repository);

  Future<Either<Failure, NoteManagementEntity>> call(String id) {
    return _repository.getById(id);
  }
}

/// สร้าง note ใหม่
///
/// **Params:** [CreateNoteParams]
/// - `name` — ชื่อ note
/// - `description` — รายละเอียด
///
/// **Business rules:**
/// - `id` generate อัตโนมัติด้วย [IdGenerator] (UUID v4)
/// - `createdAt` ใช้เวลา ณ ขณะที่เรียก usecase
///
/// **Returns:**
/// - `Right(NoteManagementEntity)` — note ที่สร้างสำเร็จ
/// - `Left(Failure)` — error จาก datasource
class CreateNoteUseCase {
  final Repository _repository;
  final IdGenerator _idGenerator;

  const CreateNoteUseCase(this._repository, this._idGenerator);

  Future<Either<Failure, NoteManagementEntity>> call(CreateNoteParams params) {
    final entity = NoteManagementEntity(
      id: _idGenerator.generate(),
      name: params.name,
      description: params.description,
      createdAt: DateTime.now(),
    );
    return _repository.create(entity);
  }
}

/// อัปเดต note ที่มีอยู่
///
/// **Params:** [UpdateNoteParams]
/// - `id` — UUID ของ note ที่ต้องการอัปเดต
/// - `name` — ชื่อใหม่
/// - `description` — รายละเอียดใหม่
///
/// **Returns:**
/// - `Right(NoteManagementEntity)` — note หลังอัปเดต
/// - `Left(NotFoundFailure)` — ไม่พบ note
/// - `Left(Failure)` — error อื่นๆ
class UpdateNoteUseCase {
  final Repository _repository;

  const UpdateNoteUseCase(this._repository);

  Future<Either<Failure, NoteManagementEntity>> call(UpdateNoteParams params) {
    final entity = NoteManagementEntity(
      id: params.id,
      name: params.name,
      description: params.description,
      createdAt: DateTime.now(),
    );
    return _repository.update(entity);
  }
}

/// ลบ note ตาม ID
///
/// **Params:** [id] — UUID ของ note ที่ต้องการลบ
///
/// **Returns:**
/// - `Right(void)` — ลบสำเร็จ
/// - `Left(Failure)` — error จาก datasource
class DeleteNoteUseCase {
  final Repository _repository;

  const DeleteNoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.delete(id);
  }
}
