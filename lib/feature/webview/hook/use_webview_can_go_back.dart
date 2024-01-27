import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/feature/webview/riverpod/webview_can_go_back_notifier.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef UseWebViewCanGoBackReturn = ({
  bool state,
  // ignore: avoid_positional_boolean_parameters
  void Function(bool) setState,
});

typedef UseWebViewCanGoBack = UseWebViewCanGoBackReturn Function();

const String _hookName = 'useWebViewCanGoBack';

UseWebViewCanGoBackReturn useWebViewCanGoBack() {
  final context = useContext();
  final ref = context as WidgetRef;

  final state = ref.watch(webViewCanGoBackNotifierProvider);

  final setState = useCallback(
    (bool value) {
      ref.read(appLoggerProvider).i(
            {'message': '$_hookName#setState', 'value': value.toString()}
                .toString(),
          );
      return ref
          .read(webViewCanGoBackNotifierProvider.notifier)
          .setState(value);
    },
    [state],
  );

  return (
    state: state,
    setState: setState,
  );
}
