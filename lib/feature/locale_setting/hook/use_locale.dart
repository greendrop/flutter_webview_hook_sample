import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/riverpod/locale_notifier.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef UseLocaleReturn = ({
  Locale? state,
  Future<void> Function() initialize,
  Future<void> Function(Locale?) update,
});

typedef UseLocale = UseLocaleReturn Function();

const String _hookName = 'useLocale';

UseLocaleReturn useLocale() {
  final context = useContext();
  final ref = context as WidgetRef;

  final state = ref.watch(localeNotifierProvider);

  final initialize = useCallback(
    () {
      ref
          .read(appLoggerProvider)
          .i({'message': '$_hookName#initialize'}.toString());
      return ref.read(localeNotifierProvider.notifier).initialize();
    },
    [state],
  );

  final update = useCallback(
    (Locale? value) {
      ref.read(appLoggerProvider).i(
            {'message': '$_hookName#update', 'value': value.toString()}
                .toString(),
          );
      return ref.read(localeNotifierProvider.notifier).setLocale(value);
    },
    [state],
  );

  return (
    state: state,
    initialize: initialize,
    update: update,
  );
}
