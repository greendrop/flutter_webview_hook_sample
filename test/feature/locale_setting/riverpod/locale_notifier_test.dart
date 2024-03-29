import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/repository/locale_repository.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/riverpod/locale_notifier.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/riverpod/locale_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../support/logger.dart';
import 'locale_notifier_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocaleRepository>(),
])
void main() {
  setUpAll(() async {
    prepareLoggerLevel();
  });

  group('LocaleNotifier', () {
    group('#initialize', () {
      test('localeRepository.fetchが呼ばれること', () async {
        final localeRepository = MockLocaleRepository();
        final container = ProviderContainer(
          overrides: [
            localeRepositoryProvider.overrideWithValue(localeRepository),
          ],
        );

        final notifier = container.read(localeNotifierProvider.notifier);
        await notifier.initialize();

        verify(localeRepository.fetch());
      });
    });
  });

  group('#setLocale', () {
    test('localeRepository.updateが呼ばれること', () async {
      final localeRepository = MockLocaleRepository();
      final container = ProviderContainer(
        overrides: [
          localeRepositoryProvider.overrideWithValue(localeRepository),
        ],
      );

      final notifier = container.read(localeNotifierProvider.notifier);
      await notifier.setLocale(const Locale('ja'));

      verify(localeRepository.update(const Locale('ja')));
    });
  });
}
