import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mustache_template/mustache.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';

Future<void> showAbout(BuildContext context) async {
  final s = S.of(context);
  final contentTemplate = await rootBundle.loadString('assets/about.md');
  final template = Template(contentTemplate);
  var content = template.renderString({'APP': APP_NAME});
  String? versionString;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String code = packageInfo.buildNumber;
  versionString = "${s.version}: $version+$code";
  if (WarpApi.hasCuda())
    versionString += "-CUDA";
  final mq = MediaQuery.of(context);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
              title: Text('${S.of(context).about} $APP_NAME'),
              contentPadding: EdgeInsets.all(16),
              content: Container(width: mq.size.width, height: mq.size.height,
                  child: SingleChildScrollView(child: Column(
                  children: [
                    MarkdownBody(data: content),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    if (versionString != null) GestureDetector(
                        onLongPress: () {resetApp(context);},
                        child: Text("$versionString"))
                  ],
                ))),
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
