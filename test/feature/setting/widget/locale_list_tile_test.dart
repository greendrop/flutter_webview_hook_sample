import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/widget/locale_setting_page.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/locale_list_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../support/logger.dart';
import '../../../support/widget/test_material_app.dart';
import 'locale_list_tile_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GoRouter>(),
])
void main() {
  setUpAll(() async {
    prepareLoggerLevel();
  });

  group('LocaleListTile', () {
    testWidgets('leading, titleが表示されること', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: LocaleListTile(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final leadingFinder = find.byKey(const Key('LocaleListTileLeadingIcon'));
      expect(leadingFinder, findsOneWidget);

      final titleFinder = find.byKey(const Key('LocaleListTileTitleText'));
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('タップして、context.pushNamedが呼ばれること', (tester) async {
      final router = MockGoRouter();

      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: InheritedGoRouter(
              goRouter: router,
              child: const Scaffold(
                body: LocaleListTile(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      when(router.pushNamed(LocaleSettingPage.routeName))
          .thenAnswer((_) async => null);

      await tester.tap(find.byType(LocaleListTile));

      verify(router.pushNamed(LocaleSettingPage.routeName));
    });
  });
}
