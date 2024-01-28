import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_logger.g.dart';

@Riverpod(keepAlive: true)
Logger appLogger(AppLoggerRef ref) {
  return Logger(printer: LogfmtPrinter());
}
