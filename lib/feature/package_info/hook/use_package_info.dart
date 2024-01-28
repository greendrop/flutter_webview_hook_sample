import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/feature/package_info/riverpod/package_info_notifier.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

typedef UsePackageInfoReturn = ({
  PackageInfo? state,
  Future<void> Function() initialize,
  Future<void> Function() refresh,
});

typedef UsePackageInfo = UsePackageInfoReturn Function();

const String _hookName = 'usePackageInfo';

UsePackageInfoReturn usePackageInfo() {
  final context = useContext();
  final ref = context as WidgetRef;

  final state = ref.watch(packageInfoNotifierProvider);

  final initialize = useCallback(
    () {
      ref
          .read(appLoggerProvider)
          .i({'message': '$_hookName#initialize'}.toString());
      return ref.read(packageInfoNotifierProvider.notifier).initialize();
    },
    [state],
  );

  final refresh = useCallback(
    () {
      ref
          .read(appLoggerProvider)
          .i({'message': '$_hookName#refresh'}.toString());
      return ref.read(packageInfoNotifierProvider.notifier).refresh();
    },
    [state],
  );

  return (
    state: state,
    initialize: initialize,
    refresh: refresh,
  );
}
