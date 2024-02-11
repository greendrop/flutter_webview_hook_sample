import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/widget/locale_setting_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../support/logger.dart';
import '../../../support/widget/test_material_app.dart';

void main() {
  setUpAll(() async {
    prepareLoggerLevel();
  });

  group('LocaleSettingForm', () {
    testWidgets('現在のlocaleがnullの場合、systemが選択されていること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: LocaleSettingForm(
                locale: null,
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final localeSystemRadioListTile = find
          .byKey(const Key('localeSystemRadioListTile'))
          .evaluate()
          .first
          .widget as RadioListTile;
      expect(
        localeSystemRadioListTile.value,
        localeSystemRadioListTile.groupValue,
      );
    });

    testWidgets('現在のlocaleがenの場合、enが選択されていること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: LocaleSettingForm(
                locale: const Locale('en'),
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final localeEnRadioListTile = find
          .byKey(const Key('localeEnRadioListTile'))
          .evaluate()
          .first
          .widget as RadioListTile;
      expect(
        localeEnRadioListTile.value,
        localeEnRadioListTile.groupValue,
      );
    });

    testWidgets('現在のlocaleがjaの場合、jaが選択されていること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: LocaleSettingForm(
                locale: const Locale('ja'),
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final localeJaRadioListTile = find
          .byKey(const Key('localeJaRadioListTile'))
          .evaluate()
          .first
          .widget as RadioListTile;
      expect(
        localeJaRadioListTile.value,
        localeJaRadioListTile.groupValue,
      );
    });

    testWidgets('Radioをタップして、onChangedが呼ばれること', (tester) async {
      Locale? locale;

      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: LocaleSettingForm(
                locale: null,
                onChanged: (value) {
                  locale = value;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('localeEnRadioListTile')));
      expect(locale, const Locale('en'));
    });
  });
}
