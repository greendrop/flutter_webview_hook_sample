import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_initial_url_effect.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_pull_to_refresh_controller.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_webview_can_go_back.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_webview_can_go_back_effect.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_webview_controller.dart';
import 'package:flutter_webview_hook_sample/feature/webview/hook/use_webview_request_go_back_effect.dart';
import 'package:flutter_webview_hook_sample/hook/use_app_logger.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:flutter_webview_hook_sample/hook/use_url_launcher_wrapper.dart';
import 'package:flutter_webview_hook_sample/widget/body_container.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class WebViewPage extends HookConsumerWidget {
  const WebViewPage({
    super.key,
    this.initialUrl = 'about:blank',
  });

  static String routeName = 'WebViewPage';

  final String initialUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLogger = useAppLogger();
    final webViewController = useWebViewController();
    final currentUrl = useState(initialUrl);
    final currentProgress = useState(0);
    final canGoBack = useWebViewCanGoBack();
    final urlLauncherWrapper = useUrlLauncherWrapper();

    useInitialUrlEffect(
      webViewController: webViewController,
      initialUrl: initialUrl,
    );
    useWebViewCanGoBackEffect(
      webViewController: webViewController,
      setCanGoBack: canGoBack.setState,
    );
    useWebViewRequestGoBackEffect(
      webViewController: webViewController,
    );

    return Scaffold(
      appBar: _appBar(
        context,
        ref,
        webViewController: webViewController,
        showLeading: canGoBack.state,
      ),
      body: SafeArea(
        child: BodyContainer(
          child: _body(
            context,
            ref,
            appLogger: appLogger,
            webViewController: webViewController,
            currentUrl: currentUrl,
            currentProgress: currentProgress,
            urlLauncherWrapper: urlLauncherWrapper,
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
    required Logger appLogger,
    required ObjectRef<InAppWebViewController?> webViewController,
    required ValueNotifier<String> currentUrl,
    required ValueNotifier<int> currentProgress,
    required UrlLauncherWrapper urlLauncherWrapper,
  }) {
    final GlobalKey webViewKey = useMemoized(GlobalKey.new);
    final webViewSettings = useMemoized(buildWebViewSettings);
    final pullToRefreshController =
        usePullToRefreshController(webViewController: webViewController);

    return Stack(
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
              if (await urlLauncherWrapper.canLaunchUrl(uri)) {
                // Launch the App
                await urlLauncherWrapper.launchUrl(
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
          onConsoleMessage: (controller, consoleMessage) {
            appLogger.i(
              {
                'message': 'WebViewPage#onConsoleMessage',
                'consoleMessage': consoleMessage.toString(),
              }.toString(),
            );
          },
        ),
        currentProgress.value < 100
            ? LinearProgressIndicator(value: currentProgress.value / 100)
            : Container(),
      ],
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
}
