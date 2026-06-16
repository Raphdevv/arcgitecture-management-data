import 'package:architecture_management_data/src/data/datasources/local/local_datasource.dart';
import 'package:architecture_management_data/src/data/datasources/remote/remote_datasource.dart';
import 'package:architecture_management_data/src/data/models/note_management_model.dart';
import 'package:architecture_management_data/src/domain/domain.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  /// ถ้า [forceLocal] เป็น true จะข้าม remote ทุก call
  /// เหมาะสำหรับ dev/test โดยไม่ต้องการ API จริง
  final bool forceLocal;

  const RepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
    this.forceLocal = false,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// ถ้า forceLocal → ใช้ local เลย
  /// ถ้าไม่ → ลอง remote ก่อน แล้ว fallback local
  Future<Either<Failure, T>> _resolve<T>({
    required Future<Either<Failure, T>> Function() remote,
    required Future<Either<Failure, T>> Function() local,
  }) async {
    if (forceLocal) return local();
    final result = await remote();
    return result.fold((_) => local(), Right.new);
  }

  @override
  Future<Either<Failure, List<NoteManagementEntity>>> getAll() async {
    return _resolve(
      remote: () async {
        final result = await _remoteDataSource.getAll();
        return result.fold(Left.new, (models) async {
          await _localDataSource.cacheAll(models);
          return Right(models);
        });
      },
      local: () async {
        final cached = await _localDataSource.getCachedAll();
        return Right(cached);
      },
    );
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> getById(String id) async {
    return _resolve(
      remote: () async {
        final result = await _remoteDataSource.getById(id);
        return result.fold(Left.new, (model) async {
          await _localDataSource.cacheOne(model);
          return Right(model);
        });
      },
      local: () async {
        final cached = await _localDataSource.getCachedById(id);
        if (cached == null) return const Left(NotFoundFailure());
        return Right(cached);
      },
    );
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> create(
    NoteManagementEntity entity,
  ) async {
    final model = NoteManagementModel.fromEntity(entity);
    return _resolve(
      remote: () async {
        final result = await _remoteDataSource.create(model);
        return result.fold(Left.new, (created) async {
          await _localDataSource.cacheOne(created);
          return Right(created);
        });
      },
      local: () async {
        await _localDataSource.cacheOne(model);
        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, NoteManagementEntity>> update(
    NoteManagementEntity entity,
  ) async {
    final model = NoteManagementModel.fromEntity(entity);
    return _resolve(
      remote: () async {
        final result = await _remoteDataSource.update(model);
        return result.fold(Left.new, (updated) async {
          await _localDataSource.cacheOne(updated);
          return Right(updated);
        });
      },
      local: () async {
        await _localDataSource.cacheOne(model);
        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    return _resolve(
      remote: () async {
        final result = await _remoteDataSource.delete(id);
        return result.fold(Left.new, (_) async {
          await _localDataSource.removeById(id);
          return const Right(null);
        });
      },
      local: () async {
        await _localDataSource.removeById(id);
        return const Right(null);
      },
    );
  }
}
