import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/config/app_theme_data.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/hook/use_locale.dart';
import 'package:flutter_webview_hook_sample/hook/use_app_router.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRoot extends HookConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialized = useState(false);
    final appRouter = useMemoized(useAppRouter);
    final locale = useLocale();
    final themeDataLight = useMemoized(() => AppThemeData().light);
    final themeDataDark = useMemoized(() => AppThemeData().dark);

    useEffect(
      () {
        Future.delayed(Duration.zero, () async {
          await locale.initialize();

          isInitialized.value = true;
        });

        return () {};
      },
      [],
    );

    if (!isInitialized.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      locale: locale.state,
      onGenerateTitle: (BuildContext context) =>
          L10n.of(context)!.commonAppTitle,
      theme: themeDataLight,
      darkTheme: themeDataDark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
