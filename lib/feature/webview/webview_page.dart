import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebViewPage extends HookConsumerWidget {
  const WebViewPage({
    super.key,
  });

  static String routeName = 'WebViewPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: const Center(
        child: Text('WebView'),
      ),
    );
  }
}
