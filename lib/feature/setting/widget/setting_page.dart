import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/config/app_constant.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/locale_list_tile.dart';
import 'package:flutter_webview_hook_sample/feature/setting/widget/setting_about_list_tile.dart';
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:flutter_webview_hook_sample/widget/body_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({
    super.key,
  });

  static String routeName = 'SettingPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _appBar(context, ref),
      body: SafeArea(
        child: BodyContainer(
          child: _body(context, ref),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, WidgetRef ref) {
    final l10n = useL10n();

    return AppBar(
      title: Text(l10n.settingTitle),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppConstant.spacing1),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstant.spacing1),
                      child: Column(
                        children: [
                          LocaleListTile(),
                          SettingAboutListTile(),
                        ],
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
