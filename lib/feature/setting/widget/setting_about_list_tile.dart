import 'package:flutter/material.dart';
import 'package:flutter_webview_hook_sample/config/app_constant.dart';
import 'package:flutter_webview_hook_sample/feature/package_info/hook/use_package_info.dart'
    as hook;
import 'package:flutter_webview_hook_sample/hook/use_l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingAboutListTile extends HookConsumerWidget {
  const SettingAboutListTile({
    super.key,
    this.usePackageInfo = hook.usePackageInfo,
  });

  final hook.UsePackageInfo usePackageInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = useL10n();
    final packageInfo = usePackageInfo();

    if (packageInfo.state == null) {
      return Container();
    }

    return AboutListTile(
      icon: const Icon(FontAwesomeIcons.info),
      applicationName: packageInfo.state!.appName,
      applicationIcon: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppConstant.spacing1),
          child: Icon(FontAwesomeIcons.circle),
        ),
      ),
      applicationVersion: packageInfo.state!.version,
      child: Text(l10n.aboutAppTitle),
    );
  }
}
