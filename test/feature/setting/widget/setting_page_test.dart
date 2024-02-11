import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/locale_list_tile.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/setting_about_list_tile.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/setting_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../support/logger.dart';
import '../../../support/widget/test_material_app.dart';

void main() {
  setUpAll(() async {
    prepareLoggerLevel();
  });

  group('SettingPage', () {
    testWidgets('ListTileが表示されること', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: TestMaterialApp(
              child: SettingPage(),
            ),
          ),
        );
      });
      await tester.pumpAndSettle();

      expect(find.byType(LocaleListTile), findsOneWidget);
      expect(find.byType(SettingAboutListTile), findsOneWidget);
    });
  });
}
