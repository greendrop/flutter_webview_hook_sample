import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/setting_page.dart';
import 'package:flutter_webview_hook_sample/feature/webview/webview_page.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScaffoldWithNavBar extends HookConsumerWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = useL10n();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(FontAwesomeIcons.globe),
            label: l10n.webviewTitleTab1,
          ),
          NavigationDestination(
            icon: const Icon(FontAwesomeIcons.globe),
            label: l10n.webviewTitleTab2,
          ),
          NavigationDestination(
            icon: const Icon(FontAwesomeIcons.gear),
            label: l10n.settingTitle,
          ),
        ],
        selectedIndex: _selectedIndex(context, ref),
        onDestinationSelected: (index) => _onDestinationSelected(
          context,
          ref,
          index: index,
        ),
      ),
    );
  }

  int _selectedIndex(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/webview')) {
      return 0;
    }

    if (location.startsWith('/setting')) {
      return 2;
    }

    return 0;
  }

  void _onDestinationSelected(
    BuildContext context,
    WidgetRef ref, {
    required int index,
  }) {
    switch (index) {
      case 0:
        context.goNamed(WebViewPage.routeName);
      case 1:
        context.goNamed(WebViewPage.routeName);
      case 2:
        context.goNamed(SettingPage.routeName);
    }
  }
}
