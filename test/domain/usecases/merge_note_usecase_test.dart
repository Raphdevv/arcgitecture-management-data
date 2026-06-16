import 'package:architecture_management_data/src/domain/entities/failure.dart';
import 'package:architecture_management_data/src/domain/entities/note_management_entity.dart';
import 'package:architecture_management_data/src/domain/usecases/merge_note_usecase.dart';
import 'package:architecture_management_data/src/domain/usecases/note_usecases.dart';
import 'package:architecture_management_data/src/domain/usecases/params/merge_note_params.dart';
import 'package:architecture_management_data/src/domain/usecases/params/note_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockRepository mockRepository;
  late MockIdGenerator mockIdGenerator;
  late CreateNoteUseCase createNoteUseCase;
  late DeleteNoteUseCase deleteNoteUseCase;
  late MergeNoteUsecase mergeNoteUsecase;

  final noteA = UpdateNoteParams(
    id: 'id-a',
    name: 'Note A',
    description: 'Description A',
  );
  final noteB = UpdateNoteParams(
    id: 'id-b',
    name: 'Note B',
    description: 'Description B',
  );

  final mergedNote = NoteManagementEntity(
    id: 'id-merged',
    name: 'Note A and Note B',
    description: 'Description A and Description B',
    createdAt: DateTime(2026),
  );

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockRepository();
    mockIdGenerator = MockIdGenerator();

    when(() => mockIdGenerator.generate()).thenReturn('id-merged');

    createNoteUseCase = CreateNoteUseCase(mockRepository, mockIdGenerator);
    deleteNoteUseCase = DeleteNoteUseCase(mockRepository);

    mergeNoteUsecase = MergeNoteUsecase(
      createNoteUseCase: createNoteUseCase,
      deleteNoteUseCase: deleteNoteUseCase,
    );
  });

  MergeNoteParams buildParams() => MergeNoteParams(content: [noteA, noteB]);

  group('MergeNoteUsecase —', () {
    group('เมื่อ create สำเร็จ', () {
      setUp(() {
        when(
          () => mockRepository.create(any()),
        ).thenAnswer((_) async => Right(mergedNote));

        when(
          () => mockRepository.delete(any()),
        ).thenAnswer((_) async => const Right(null));
      });

      test('ควร concat name ของทั้งสองด้วย " and "', () async {
        await mergeNoteUsecase(params: buildParams());

        final captured =
            verify(() => mockRepository.create(captureAny())).captured.first
                as NoteManagementEntity;

        expect(captured.name, 'Note A and Note B');
      });

      test('ควร concat description ของทั้งสองด้วย " and "', () async {
        await mergeNoteUsecase(params: buildParams());

        final captured =
            verify(() => mockRepository.create(captureAny())).captured.first
                as NoteManagementEntity;

        expect(captured.description, 'Description A and Description B');
      });

      test('ควรคืน Right พร้อม note ที่ merge แล้ว', () async {
        final result = await mergeNoteUsecase(params: buildParams());

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('ไม่ควร return Left'),
          (note) => expect(note.id, mergedNote.id),
        );
      });

      test('ควรลบ note A ด้วย id ที่ถูกต้อง', () async {
        await mergeNoteUsecase(params: buildParams());

        verify(() => mockRepository.delete('id-a')).called(1);
      });

      test('ควรลบ note B ด้วย id ที่ถูกต้อง', () async {
        await mergeNoteUsecase(params: buildParams());

        verify(() => mockRepository.delete('id-b')).called(1);
      });

      test('ควรลบทั้งสอง note (รวม 2 ครั้ง)', () async {
        await mergeNoteUsecase(params: buildParams());

        verify(() => mockRepository.delete(any())).called(2);
      });
    });

    group('เมื่อ create ล้มเหลว', () {
      const failure = ServerFailure(statusCode: 500, message: 'Server error');

      setUp(() {
        when(
          () => mockRepository.create(any()),
        ).thenAnswer((_) async => const Left(failure));
      });

      test('ควรคืน Left พร้อม failure ที่ได้รับ', () async {
        final result = await mergeNoteUsecase(params: buildParams());

        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, isA<ServerFailure>()),
          (_) => fail('ไม่ควร return Right'),
        );
      });

      test('ต้องไม่ลบ note ใดเลยเมื่อ create ล้มเหลว', () async {
        await mergeNoteUsecase(params: buildParams());

        verifyNever(() => mockRepository.delete(any()));
      });
    });
  });
}
