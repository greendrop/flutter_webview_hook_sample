import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:flutter_webview_hook_sample/widget/body_container.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends HookConsumerWidget {
  const WebViewPage({
    super.key,
    this.initialUrl = 'about:blank',
  });

  static String routeName = 'WebViewPage';

  final String initialUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webViewController = useRef<InAppWebViewController?>(null);
    final currentUrl = useState(initialUrl);
    final currentProgress = useState(0);
    final canGoBack = useState(false);
    final canGoBackSnapshot = useFuture(webViewController.value?.canGoBack());

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

    useEffect(
      () {
        canGoBack.value = canGoBackSnapshot.data ?? false;
        return () {};
      },
      [canGoBackSnapshot.data],
    );

    return Scaffold(
      appBar: _appBar(
        context,
        ref,
        webViewController: webViewController,
        showLeading: canGoBack.value,
      ),
      body: SafeArea(
        child: BodyContainer(
          child: _body(
            context,
            ref,
            webViewController: webViewController,
            currentUrl: currentUrl,
            currentProgress: currentProgress,
          ),
        ),
      ),
    );
  }

  AppBar _appBar(
    BuildContext context,
    WidgetRef ref, {
    required ObjectRef<InAppWebViewController?> webViewController,
    bool showLeading = false,
  }) {
    final l10n = useL10n();

    final title = Text(l10n.webviewTitle);
    if (!showLeading) {
      return AppBar(title: title);
    }

    final leading = FutureBuilder(
      future: webViewController.value?.canGoBack(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return IconButton(
            icon: Icon(
              defaultTargetPlatform == TargetPlatform.iOS
                  ? Icons.arrow_back_ios
                  : Icons.arrow_back,
            ),
            onPressed: () async {
              if (await webViewController.value?.canGoBack() ?? false) {
                await webViewController.value?.goBack();
              } else {
                if (context.mounted) {
                  context.pop();
                }
              }
            },
          );
        } else {
          return Container();
        }
      },
    );

    return AppBar(title: title, leading: leading);
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref, {
    required ObjectRef<InAppWebViewController?> webViewController,
    required ValueNotifier<String> currentUrl,
    required ValueNotifier<int> currentProgress,
  }) {
    final GlobalKey webViewKey = useMemoized(GlobalKey.new);
    final webViewSettings = useMemoized(buildWebViewSettings);
    final pullToRefreshController = useMemoized(
      () => buildPullToRefreshController(
        webViewController: webViewController,
      ),
    );

    return Expanded(
      child: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
            initialSettings: webViewSettings,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController.value = controller;
            },
            onLoadStart: (controller, url) {
              currentUrl.value = url.toString();
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url!;

              if (![
                'http',
                'https',
                'file',
                'chrome',
                'data',
                'javascript',
                'about',
              ].contains(uri.scheme)) {
                if (await canLaunchUrl(uri)) {
                  // Launch the App
                  await launchUrl(
                    uri,
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              await pullToRefreshController?.endRefreshing();
            },
            onReceivedError: (controller, request, error) {
              pullToRefreshController?.endRefreshing();
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController?.endRefreshing();
              }
              currentProgress.value = progress;
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              currentUrl.value = url.toString();
            },
            onConsoleMessage: (controller, consoleMessage) {},
          ),
          currentProgress.value < 100
              ? LinearProgressIndicator(value: currentProgress.value / 100)
              : Container(),
        ],
      ),
    );
  }

  InAppWebViewSettings buildWebViewSettings() {
    return InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: 'camera; microphone',
      iframeAllowFullscreen: true,
    );
  }

  PullToRefreshController? buildPullToRefreshController({
    required ObjectRef<InAppWebViewController?> webViewController,
  }) {
    if (kIsWeb) {
      return null;
    }

    return PullToRefreshController(
      settings: PullToRefreshSettings(),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          await webViewController.value?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          await webViewController.value?.loadUrl(
            urlRequest:
                URLRequest(url: await webViewController.value?.getUrl()),
          );
        }
      },
    );
  }
}
