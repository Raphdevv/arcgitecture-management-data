import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:architecture_management_data/src/domain/repositories/repository.dart';
import 'package:architecture_management_data/src/domain/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'params/note_params.dart';

class GetAllNoteUseCase {
  final Repository _repository;

  const GetAllNoteUseCase(this._repository);

  Future<Either<Failure, List<NoteManagementEntity>>> call() {
    return _repository.getAll();
  }
}

class GetNoteByIdUseCase {
  final Repository _repository;

  const GetNoteByIdUseCase(this._repository);

  Future<Either<Failure, NoteManagementEntity>> call(String id) {
    return _repository.getById(id);
  }
}

/// Presentation ส่ง [CreateNoteParams] มา
/// UseCase รับผิดชอบสร้าง id และ createdAt เอง (business rule)
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

/// Presentation ส่ง [UpdateNoteParams] มา
/// UseCase แปลงเป็น Entity แล้วส่งไป Repository
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

class DeleteNoteUseCase {
  final Repository _repository;

  const DeleteNoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.delete(id);
  }
}
