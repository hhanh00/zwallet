import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showAbout(BuildContext context) async {
  final content = await rootBundle.loadString('assets/about.md');
  showDialog(context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('About ZWallet'),
          content: Container(width: double.maxFinite, child: Markdown(data: content)),
          actions: [
            ElevatedButton(onPressed: () { Navigator.of(context).pop(); }, child: Text('OK'))
          ]

      ));


}

Future<void> showAboutOnce(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final about = prefs.getBool('about');
  if (about == null) {
    await showAbout(context);
    prefs.setBool('about', true);
  }
}