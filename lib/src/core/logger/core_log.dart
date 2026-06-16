import 'package:flutter/foundation.dart';

/// Log level สำหรับ filter ว่าจะแสดง log ระดับไหน
enum LogLevel { debug, info, warning, error }

/// Interface สำหรับ Logger
///
/// Inject เข้า class ที่ต้องการ log เพื่อให้ mock ได้ใน test
/// และเปลี่ยน implementation ได้โดยไม่แตะโค้ดที่ใช้งาน
///
/// Implementations:
/// - [CoreLog] — แสดงผลใน console (ใช้ใน dev)
/// - [SilentLog] — ไม่แสดงผลอะไร (ใช้ใน test)
abstract interface class AppLogger {
  void debug(String message, {String? tag});
  void info(String message, {String? tag});
  void warning(String message, {String? tag});
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Logger สำหรับ production/development
///
/// แสดง log ใน console พร้อม level icon, timestamp, tag
///
/// **ปิด/เปิดตาม environment:**
/// ```dart
/// CoreLog(minLevel: kReleaseMode ? LogLevel.error : LogLevel.debug)
/// ```
///
/// **Example:**
/// ```dart
/// final logger = CoreLog();
/// logger.debug('getAll called', tag: 'Repository');
/// logger.error('Network failed', tag: 'RemoteDataSource', error: e, stackTrace: st);
/// ```
class CoreLog implements AppLogger {
  const CoreLog({this.minLevel = LogLevel.debug});

  /// ระดับต่ำสุดที่จะแสดง — log ที่ต่ำกว่านี้จะถูกข้าม
  final LogLevel minLevel;

  @override
  void debug(String message, {String? tag}) =>
      _output(LogLevel.debug, message, tag: tag);

  @override
  void info(String message, {String? tag}) =>
      _output(LogLevel.info, message, tag: tag);

  @override
  void warning(String message, {String? tag}) =>
      _output(LogLevel.warning, message, tag: tag);

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) => _output(
    LogLevel.error,
    message,
    tag: tag,
    error: error,
    stackTrace: stackTrace,
  );

  static const _icons = {
    LogLevel.debug: '🔍',
    LogLevel.info: 'ℹ️ ',
    LogLevel.warning: '⚠️ ',
    LogLevel.error: '🔴',
  };

  void _output(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;

    final icon = _icons[level]!;
    final prefix = tag != null ? '[$tag] ' : '';
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);

    debugPrint('$icon $timestamp $prefix$message');
    if (error != null) debugPrint('   ↳ error: $error');
    if (stackTrace != null) debugPrint('   ↳ trace: $stackTrace');
  }
}

/// Logger ที่ไม่แสดงผลอะไร — ใช้ใน test เพื่อไม่ให้ log รบกวน output
///
/// ```dart
/// final repo = RepositoryImpl(
///   remoteDataSource: mockRemote,
///   localDataSource: mockLocal,
///   logger: SilentLog(),
/// );
/// ```
class SilentLog implements AppLogger {
  const SilentLog();

  @override
  void debug(String message, {String? tag}) {}

  @override
  void info(String message, {String? tag}) {}

  @override
  void warning(String message, {String? tag}) {}

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}
