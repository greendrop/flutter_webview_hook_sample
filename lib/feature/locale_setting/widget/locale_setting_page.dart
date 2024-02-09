import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/config/app_constant.dart';
import 'package:flutter_webview_hook_sample/feature/locale_setting/hook/use_locale.dart'
    as hook;
import 'package:flutter_webview_hook_sample/feature/locale_setting/widget/locale_setting_form.dart';
import 'package:flutter_webview_hook_sample/hook/use_translations.dart';
import 'package:flutter_webview_hook_sample/widget/body_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocaleSettingPage extends HookConsumerWidget {
  const LocaleSettingPage({
    super.key,
    this.dummyAd = false,
    this.useLocale = hook.useLocale,
  });

  static String routeName = 'LocaleSettingPage';

  final bool dummyAd;
  final hook.UseLocale useLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = useLocale();

    return Scaffold(
      appBar: _appBar(context, ref),
      body: BodyContainer(
        child: _body(context, ref, locale: locale),
      ),
    );
  }

  AppBar _appBar(BuildContext context, WidgetRef ref) {
    final translations = useTranslations();

    return AppBar(
      title: Text(translations.localeSetting.title),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref, {
    required hook.UseLocaleReturn locale,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.spacing1),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstant.spacing1),
                      child: LocaleSettingForm(
                        locale: locale.state,
                        onChanged: (value) {
                          locale.update(value);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
