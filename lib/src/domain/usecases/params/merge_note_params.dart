import 'package:architecture_management_data/src/domain/usecases/params/note_params.dart';

class MergeNoteParams {
  final List<UpdateNoteParams> content;

  MergeNoteParams({required this.content});
}
