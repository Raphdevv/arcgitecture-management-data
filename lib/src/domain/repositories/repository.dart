import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, List<NoteManagementEntity>>> getAll();
  Future<Either<Failure, NoteManagementEntity>> getById(String id);
  Future<Either<Failure, NoteManagementEntity>> create(
    NoteManagementEntity entity,
  );
  Future<Either<Failure, NoteManagementEntity>> update(
    NoteManagementEntity entity,
  );
  Future<Either<Failure, void>> delete(String id);
}
