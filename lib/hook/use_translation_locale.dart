import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/i18n/strings.g.dart';

Locale useTranslationLocale() {
  return TranslationProvider.of(useContext()).flutterLocale;
}
