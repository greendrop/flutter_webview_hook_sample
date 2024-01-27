import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/riverpod/url_launcher_wrapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'package:flutter_webview_hook_sample/riverpod/url_launcher_wrapper.dart';

UrlLauncherWrapper useUrlLauncherWrapper() {
  return (useContext() as WidgetRef).watch(urlLauncherWrapperProvider);
}
