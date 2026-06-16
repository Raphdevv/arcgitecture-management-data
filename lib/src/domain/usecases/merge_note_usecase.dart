import 'package:architecture_management_data/src/core/logger/core_log.dart';
import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:architecture_management_data/src/domain/usecases/note_usecases.dart';
import 'package:architecture_management_data/src/domain/usecases/params/merge_note_params.dart';
import 'package:architecture_management_data/src/domain/usecases/params/note_params.dart';
import 'package:dartz/dartz.dart';

/// Merge 2 notes เป็น note ใหม่ แล้วลบต้นทาง
///
/// **Params:** [MergeNoteParams]
/// - `content[0]` — note แรก
/// - `content[1]` — note ที่สอง
///
/// **Flow:**
/// 1. ต่อ `name`: `'A and B'`
/// 2. ต่อ `description`: `'X and Y'`
/// 3. เรียก [CreateNoteUseCase]
/// 4. ถ้า create สำเร็จ → ลบต้นทางทั้งสองแบบ sequential
/// 5. ถ้า create ล้มเหลว → คืน `Left(failure)` ไม่มีการลบ
///
/// **หมายเหตุ:** delete ต้องทำ sequential เพราะ [LocalDataSource]
/// ทำ read-modify-write — ถ้า parallel จะเกิด race condition
///
/// **Returns:**
/// - `Right(NoteManagementEntity)` — note ใหม่ที่ merge แล้ว
/// - `Left(Failure)` — create ล้มเหลว (note ต้นทางยังอยู่ครบ)
class MergeNoteUsecase {
  const MergeNoteUsecase({
    required CreateNoteUseCase createNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    AppLogger logger = const SilentLog(),
  }) : _createNoteUseCase = createNoteUseCase,
       _deleteNoteUseCase = deleteNoteUseCase,
       _logger = logger;

  final CreateNoteUseCase _createNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final AppLogger _logger;

  Future<Either<Failure, NoteManagementEntity>> call({
    required MergeNoteParams params,
  }) async {
    final contentA = params.content[0];
    final contentB = params.content[1];

    _logger.debug(
      'merging note ${contentA.id} + ${contentB.id}',
      tag: 'MergeNoteUsecase',
    );

    final createResult = await _createNoteUseCase(
      CreateNoteParams(
        name: _concat(contentA.name, contentB.name),
        description: _concat(contentA.description, contentB.description),
      ),
    );

    return createResult.fold(
      (failure) {
        _logger.error(
          'create failed: ${failure.message}',
          tag: 'MergeNoteUsecase',
        );
        return Left(failure);
      },
      (result) async {
        _logger.debug(
          'create success, deleting originals',
          tag: 'MergeNoteUsecase',
        );
        await _deleteNoteUseCase(contentA.id);
        await _deleteNoteUseCase(contentB.id);
        _logger.info('merge complete → ${result.id}', tag: 'MergeNoteUsecase');
        return Right(result);
      },
    );
  }

  String _concat(String a, String b) => '$a and $b';
}
