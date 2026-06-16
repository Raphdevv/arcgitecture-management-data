import 'package:dartz/dartz.dart';

import '../entities/architecture_management_entity.dart';
import '../entities/failure.dart';

abstract class ArchitectureManagementRepository {
  Future<Either<Failure, List<ArchitectureManagementEntity>>> getAll();
  Future<Either<Failure, ArchitectureManagementEntity>> getById(String id);
  Future<Either<Failure, ArchitectureManagementEntity>> create(
    ArchitectureManagementEntity entity,
  );
  Future<Either<Failure, ArchitectureManagementEntity>> update(
    ArchitectureManagementEntity entity,
  );
  Future<Either<Failure, void>> delete(String id);
}
