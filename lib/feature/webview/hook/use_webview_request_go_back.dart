import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/feature/webview/riverpod/webview_request_go_back_notifier.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef UseWebViewRequestGoBackReturn = ({
  bool state,
  // ignore: avoid_positional_boolean_parameters
  void Function(bool) setState,
});

typedef UseWebViewRequestGoBack = UseWebViewRequestGoBackReturn Function();

const String _hookName = 'useWebViewRequestGoBack';

UseWebViewRequestGoBackReturn useWebViewRequestGoBack() {
  final context = useContext();
  final ref = context as WidgetRef;

  final state = ref.watch(webViewRequestGoBackNotifierProvider);

  final setState = useCallback(
    (bool value) {
      ref.read(appLoggerProvider).i(
            {'message': '$_hookName#setState', 'value': value.toString()}
                .toString(),
          );
      return ref
          .read(webViewRequestGoBackNotifierProvider.notifier)
          .setState(value);
    },
    [state],
  );

  return (
    state: state,
    setState: setState,
  );
}
