/// Base class สำหรับ error ทุกประเภทในระบบ
///
/// ใช้เป็น `Left` ใน `Either<Failure, T>`
/// ใช้ `switch` หรือ pattern matching เพื่อแยก error type:
/// ```dart
/// result.fold(
///   (failure) => switch (failure) {
///     NetworkFailure()  => showNoInternetBanner(),
///     ServerFailure()   => showServerError(),
///     NotFoundFailure() => showEmptyState(),
///     _                 => showGenericError(),
///   },
///   (data) => showData(data),
/// );
/// ```
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Network ไม่พร้อม เช่น timeout, no connection, socket error
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Server ตอบกลับ HTTP status code ที่ไม่ใช่ 2xx
class ServerFailure extends Failure {
  /// HTTP status code เช่น 400, 401, 403, 500
  final int statusCode;
  const ServerFailure({required this.statusCode, required String message})
    : super(message);
}

/// JSON response มี field ผิด type หรือ parse ไม่ได้
class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to parse response']);
}

/// ไม่พบข้อมูลที่ต้องการ (HTTP 404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Error ที่ไม่ได้คาดการณ์ไว้
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
