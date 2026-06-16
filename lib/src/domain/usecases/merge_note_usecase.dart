import 'package:architecture_management_data/src/domain/entities/entities.dart';
import 'package:architecture_management_data/src/domain/usecases/note_usecases.dart';
import 'package:architecture_management_data/src/domain/usecases/params/merge_note_params.dart';
import 'package:architecture_management_data/src/domain/usecases/params/note_params.dart';
import 'package:dartz/dartz.dart';

class MergeNoteUsecase {
  const MergeNoteUsecase({
    required CreateNoteUseCase createNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
  }) : _createNoteUseCase = createNoteUseCase,
       _deleteNoteUseCase = deleteNoteUseCase;

  final CreateNoteUseCase _createNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;

  Future<Either<Failure, NoteManagementEntity>> call({
    required MergeNoteParams params,
  }) async {
    final contentA = params.content[0];
    final contentB = params.content[1];

    final createResult = await _createNoteUseCase(
      CreateNoteParams(
        name: _concat(contentA.name, contentB.name),
        description: _concat(contentA.description, contentB.description),
      ),
    );

    return createResult.fold(Left.new, (result) async {
      await _deleteNoteUseCase(contentA.id);
      await _deleteNoteUseCase(contentB.id);

      return Right(result);
    });
  }

  String _concat(String a, String b) => '$a and $b';
}
