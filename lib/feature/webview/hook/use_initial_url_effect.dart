import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void useInitialUrlEffect({
  required ObjectRef<InAppWebViewController?> webViewController,
  required String initialUrl,
}) {
  useEffect(
    () {
      webViewController.value
          ?.loadUrl(
            urlRequest: URLRequest(url: WebUri(initialUrl)),
          )
          .then((value) => webViewController.value?.clearHistory());
      return () {};
    },
    [initialUrl],
  );
}
