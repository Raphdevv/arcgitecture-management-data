sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class ServerFailure extends Failure {
  final int statusCode;
  const ServerFailure({required this.statusCode, required String message})
    : super(message);
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to parse response']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
