import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/app_root.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AppRoot()));
}
