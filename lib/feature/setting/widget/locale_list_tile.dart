import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/widget/locale_setting_page.dart';
import 'package:flutter_webview_hook_sample/hook/use_translations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocaleListTile extends HookConsumerWidget {
  const LocaleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = useTranslations();

    return ListTile(
      leading: const Icon(
        key: Key('LocaleListTileLeadingIcon'),
        FontAwesomeIcons.language,
      ),
      title: Text(
        key: const Key('LocaleListTileTitleText'),
        translations.localeSetting.title,
      ),
      onTap: () => context.pushNamed(LocaleSettingPage.routeName),
    );
  }
}
