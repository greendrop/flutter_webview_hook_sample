import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocaleSettingForm extends HookConsumerWidget {
  const LocaleSettingForm({
    super.key,
    required this.locale,
    required this.onChanged,
  });

  final Locale? locale;
  final void Function(Locale?)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final l10n = useL10n();

    return Form(
      key: formKey,
      child: Column(
        children: <RadioListTile<Locale?>>[
          RadioListTile(
            key: const Key('localeSystemRadioListTile'),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(l10n.localeSettingSystem),
            value: null,
            groupValue: locale,
            onChanged: onChanged,
          ),
          RadioListTile(
            key: const Key('localeEnRadioListTile'),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(l10n.localeSettingEnglish),
            value: const Locale('en'),
            groupValue: locale,
            onChanged: onChanged,
          ),
          RadioListTile(
            key: const Key('localeJaRadioListTile'),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(l10n.localeSettingJapanese),
            value: const Locale('ja'),
            groupValue: locale,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
