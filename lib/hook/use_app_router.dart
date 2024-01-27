import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/widget/locale_setting_page.dart';
import 'package:flutter_webview_hook_sample/feature/not_found/widget/not_found_page.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/setting_page.dart';
import 'package:flutter_webview_hook_sample/feature/webview/webview_page.dart';
import 'package:flutter_webview_hook_sample/riverpod/app_logger.dart';
import 'package:flutter_webview_hook_sample/widget/scaffold_with_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter useAppRouter({String initialLocation = '/webview'}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/webview',
            name: WebViewPage.routeName,
            builder: (context, state) {
              return const WebViewPage();
            },
          ),
          GoRoute(
            path: '/setting',
            name: SettingPage.routeName,
            builder: (context, state) {
              return const SettingPage();
            },
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: 'locale',
                name: LocaleSettingPage.routeName,
                builder: (context, state) {
                  return const LocaleSettingPage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/:path(.*)',
        name: NotFoundPage.routeName,
        builder: (context, state) {
          return const NotFoundPage();
        },
      ),
    ],
    observers: [
      _LoggerNavigatorObserver(
        logger: (useContext() as WidgetRef).watch(appLoggerProvider),
      ),
    ],
  );
}

class _LoggerNavigatorObserver extends NavigatorObserver {
  _LoggerNavigatorObserver({required this.logger});

  final Logger logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    logger.i(
      {
        'message': 'Navigator didPush',
        'settingsName': route.settings.name,
        'settingsArguments': route.settings.arguments.toString(),
      }.toString(),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logger.i(
      {
        'message': 'Navigator didPop',
        'settingsName': route.settings.name,
        'settingsArguments': route.settings.arguments.toString(),
      }.toString(),
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    logger.i(
      {
        'message': 'Navigator didPop',
        'settingsName': route.settings.name,
        'settingsArguments': route.settings.arguments.toString(),
      }.toString(),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    logger.i(
      {
        'message': 'Navigator didReplace',
        'settingsName': newRoute?.settings.name,
        'settingsArguments': newRoute?.settings.arguments.toString(),
      }.toString(),
    );
  }
}
