import 'package:dartz/dartz.dart';

import '../../domain/entities/note_management_entity.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/note_management_model.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  const RepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<NoteManagementEntity>>> getAll() async {
    final result = await _remoteDataSource.getAll();
    return result.fold(
      (failure) async {
        // Fallback: ดึงจาก local cache
        final cached = await _localDataSource.getCachedAll();
        return Right(cached);
      },
      (models) async {
        await _localDataSource.cacheAll(models);
        return Right(models);
      },
    );
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> getById(String id) async {
    final result = await _remoteDataSource.getById(id);
    return result.fold(
      (failure) async {
        final cached = await _localDataSource.getCachedById(id);
        if (cached == null) return Left(failure);
        return Right(cached);
      },
      (model) async {
        await _localDataSource.cacheOne(model);
        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> create(
    NoteManagementEntity entity,
  ) async {
    final model = NoteManagementModel.fromEntity(entity);
    final result = await _remoteDataSource.create(model);
    return result.fold(Left.new, (created) async {
      await _localDataSource.cacheOne(created);
      return Right(created);
    });
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> update(
    NoteManagementEntity entity,
  ) async {
    final model = NoteManagementModel.fromEntity(entity);
    final result = await _remoteDataSource.update(model);
    return result.fold(Left.new, (updated) async {
      await _localDataSource.cacheOne(updated);
      return Right(updated);
    });
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    final result = await _remoteDataSource.delete(id);
    return result.fold(Left.new, (_) async {
      await _localDataSource.removeById(id);
      return const Right(null);
    });
  }
}
