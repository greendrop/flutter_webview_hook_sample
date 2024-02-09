import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/i18n/strings.g.dart';

export 'package:flutter_webview_hook_sample/i18n/strings.g.dart';

Translations useTranslations() {
  return Translations.of(useContext());
}
