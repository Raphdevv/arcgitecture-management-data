import 'package:dartz/dartz.dart';

import '../entities/architecture_management_entity.dart';
import '../entities/failure.dart';
import '../repositories/architecture_management_repository.dart';

class GetAllArchitectureManagementUseCase {
  final ArchitectureManagementRepository _repository;

  const GetAllArchitectureManagementUseCase(this._repository);

  Future<Either<Failure, List<ArchitectureManagementEntity>>> call() {
    return _repository.getAll();
  }
}

class GetArchitectureManagementByIdUseCase {
  final ArchitectureManagementRepository _repository;

  const GetArchitectureManagementByIdUseCase(this._repository);

  Future<Either<Failure, ArchitectureManagementEntity>> call(String id) {
    return _repository.getById(id);
  }
}

class CreateArchitectureManagementUseCase {
  final ArchitectureManagementRepository _repository;

  const CreateArchitectureManagementUseCase(this._repository);

  Future<Either<Failure, ArchitectureManagementEntity>> call(
    ArchitectureManagementEntity entity,
  ) {
    return _repository.create(entity);
  }
}

class UpdateArchitectureManagementUseCase {
  final ArchitectureManagementRepository _repository;

  const UpdateArchitectureManagementUseCase(this._repository);

  Future<Either<Failure, ArchitectureManagementEntity>> call(
    ArchitectureManagementEntity entity,
  ) {
    return _repository.update(entity);
  }
}

class DeleteArchitectureManagementUseCase {
  final ArchitectureManagementRepository _repository;

  const DeleteArchitectureManagementUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.delete(id);
  }
}
