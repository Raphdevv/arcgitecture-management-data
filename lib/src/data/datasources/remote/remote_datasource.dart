import 'package:dartz/dartz.dart';

import '../../../domain/entities/failure.dart';
import '../../models/note_management_model.dart';

abstract class RemoteDataSource {
  Future<Either<Failure, List<NoteManagementModel>>> getAll();
  Future<Either<Failure, NoteManagementModel>> getById(String id);
  Future<Either<Failure, NoteManagementModel>> create(
    NoteManagementModel model,
  );
  Future<Either<Failure, NoteManagementModel>> update(
    NoteManagementModel model,
  );
  Future<Either<Failure, void>> delete(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final bool _shouldFail;

  const RemoteDataSourceImpl({bool shouldFail = false})
    : _shouldFail = shouldFail;

  static const _fakeDelay = Duration(milliseconds: 800);

  /// Mock data — แทน response จาก API จริง
  static final List<Map<String, dynamic>> _mockData = [
    {
      'id': '1',
      'name': 'Clean Note',
      'description': 'แยก layer ชัดเจน domain / data / presentation',
      'created_at': '2026-01-01T00:00:00.000Z',
    },
    {
      'id': '2',
      'name': 'Hexagonal Note',
      'description': 'Port & Adapter แยก core ออกจาก external',
      'created_at': '2026-02-01T00:00:00.000Z',
    },
    {
      'id': '3',
      'name': 'Microservices',
      'description': 'แบ่ง service ย่อยๆ deploy อิสระต่อกัน',
      'created_at': '2026-03-01T00:00:00.000Z',
    },
  ];

  /// จำลอง network delay แล้วตรวจว่าควร fail ไหม
  /// ครอบ try-catch เพื่อให้ Exception ทุกชนิด (parse error, network ฯลฯ)
  /// กลายเป็น Left แทนที่จะ throw ออกไป
  Future<Either<Failure, T>> _simulateRequest<T>(
    T Function() buildResult,
  ) async {
    try {
      await Future<void>.delayed(_fakeDelay);
      if (_shouldFail) {
        return const Left(
          ServerFailure(statusCode: 500, message: 'Internal server error'),
        );
      }
      // buildResult อาจ throw ได้ เช่น fromJson map ผิด type
      return Right(buildResult());
    } on FormatException {
      return const Left(ParseFailure('Invalid date format in response'));
    } on TypeError {
      return const Left(ParseFailure('Response field type mismatch'));
    } catch (_) {
      return const Left(NetworkFailure('Unable to reach the server'));
    }
  }

  @override
  Future<Either<Failure, List<NoteManagementModel>>> getAll() {
    return _simulateRequest(
      () => _mockData.map(NoteManagementModel.fromJson).toList(),
    );
  }

  @override
  Future<Either<Failure, NoteManagementModel>> getById(String id) async {
    try {
      await Future<void>.delayed(_fakeDelay);
      if (_shouldFail) {
        return const Left(
          ServerFailure(statusCode: 500, message: 'Internal server error'),
        );
      }
      final json = _mockData.where((e) => e['id'] == id).firstOrNull;
      if (json == null) {
        return const Left(NotFoundFailure('Note management not found'));
      }
      return Right(NoteManagementModel.fromJson(json));
    } on FormatException {
      return const Left(ParseFailure('Invalid date format in response'));
    } on TypeError {
      return const Left(ParseFailure('Response field type mismatch'));
    } catch (_) {
      return const Left(NetworkFailure('Unable to reach the server'));
    }
  }

  @override
  Future<Either<Failure, NoteManagementModel>> create(
    NoteManagementModel model,
  ) {
    return _simulateRequest(() => model);
  }

  @override
  Future<Either<Failure, NoteManagementModel>> update(
    NoteManagementModel model,
  ) {
    return _simulateRequest(() => model);
  }

  @override
  Future<Either<Failure, void>> delete(String id) {
    return _simulateRequest<void>(() {});
  }
}
