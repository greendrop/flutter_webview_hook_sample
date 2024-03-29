import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_webview_hook_sample/config/app_theme_data.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/hook/use_locale.dart';
import 'package:flutter_webview_hook_sample/feature/package_info/hook/use_package_info.dart';
import 'package:flutter_webview_hook_sample/hook/use_app_router.dart';
import 'package:flutter_webview_hook_sample/i18n/strings.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRoot extends HookConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialized = useState(false);
    final appRouter = useMemoized(useAppRouter);
    final locale = useLocale();
    final packageInfo = usePackageInfo();
    final themeDataLight = useMemoized(() => AppThemeData().light);
    final themeDataDark = useMemoized(() => AppThemeData().dark);

    useEffect(
      () {
        Future.delayed(Duration.zero, () async {
          await packageInfo.initialize();
          await locale.initialize();

          isInitialized.value = true;
        });

        return () {};
      },
      [],
    );

    useEffect(
      () {
        Future.delayed(Duration.zero, () {
          if (locale.state == null) {
            LocaleSettings.useDeviceLocale();
          } else {
            LocaleSettings.setLocaleRaw(locale.state!.toString());
          }
        });
        return () {};
      },
      [locale.state],
    );

    if (!isInitialized.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return MaterialApp.router(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
      locale: TranslationProvider.of(context).flutterLocale,
      onGenerateTitle: (BuildContext context) =>
          Translations.of(context).common.appTitle,
      theme: themeDataLight,
      darkTheme: themeDataDark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
