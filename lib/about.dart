import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mustache_template/mustache.dart';

import 'main.dart';
import 'generated/l10n.dart';

Future<void> showAbout(BuildContext context) async {
  final contentTemplate = await rootBundle.loadString('assets/about.md');
  final template = Template(contentTemplate);
  var content = template.renderString({'APP': APP_NAME});
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String code = packageInfo.buildNumber;
  content += "`${S.of(context).version}: $version+$code`";
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
              title: Text('${S.of(context).about} $APP_NAME'),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                child: Markdown(data: content),
              ),
              actions: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Text(S.of(context).ok),
                    icon: Icon(Icons.done))
              ]));
}

Future<void> showAboutOnce(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final about = prefs.getBool('about');
  if (about == null) {
    await showAbout(context);
    prefs.setBool('about', true);
  }
}
