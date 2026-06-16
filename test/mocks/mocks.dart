import 'package:architecture_management_data/src/domain/repositories/repository.dart';
import 'package:architecture_management_data/src/domain/utils/id_generator.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

class MockIdGenerator extends Mock implements IdGenerator {}
