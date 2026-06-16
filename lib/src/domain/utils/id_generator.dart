import 'package:uuid/uuid.dart';

abstract class IdGenerator {
  String generate();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  @override
  String generate() => const Uuid().v4();
}

class SequentialIdGenerator implements IdGenerator {
  int _counter;

  SequentialIdGenerator({int start = 0}) : _counter = start;

  @override
  String generate() => (++_counter).toString();
}
