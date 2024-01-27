import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

Logger useAppLogger() {
  return (useContext() as WidgetRef).watch(appLoggerProvider);
}
