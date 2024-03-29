import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_hook_sample/feature/webview/riverpod/webview_request_go_back_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void useWebViewRequestGoBackEffect({
  required ObjectRef<InAppWebViewController?> webViewController,
}) {
  final context = useContext();
  final ref = context as WidgetRef;

  final requestGoBack = ref.watch(webViewRequestGoBackNotifierProvider);
  useEffect(
    () {
      if (requestGoBack) {
        Future.delayed(Duration.zero, () async {
          if (await webViewController.value?.canGoBack() ?? false) {
            await webViewController.value?.goBack();
          }
          await ref
              .read(webViewRequestGoBackNotifierProvider.notifier)
              .setState(false);
        });
      }
      return () {};
    },
    [requestGoBack],
  );
}
