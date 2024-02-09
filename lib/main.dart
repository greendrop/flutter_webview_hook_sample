import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_hook_sample/app_root.dart';
import 'package:flutter_webview_hook_sample/i18n/strings.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _prepareWebView();

  runApp(ProviderScope(child: TranslationProvider(child: const AppRoot())));
}

Future<void> _prepareWebView() async {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
}
