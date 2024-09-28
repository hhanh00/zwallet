import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mustache_template/mustache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../src/version.dart';
import '../../appsettings.dart';
import '../utils.dart';

class AboutPage extends StatelessWidget {
  final String contentTemplate;
  AboutPage(this.contentTemplate);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final template = Template(contentTemplate);
    var content = template.renderString({'APP': APP_NAME});
    final id = commitId.substring(0, 8);
    final versionString = "${s.version}: $packageVersion/$id";
    return Scaffold(
        appBar: AppBar(title: Text(s.about)),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                MarkdownBody(data: content),
                Gap(16),
                SelectableText(appStore.dbDir, style: t.textTheme.labelSmall),
                Gap(8),
                TextButton(
                    child: Text(versionString),
                    onPressed: () => openGithub(commitId)),
              ],
            ),
          ),
        ));
  }

  openGithub(String commitId) {
    launchUrl(Uri.parse("https://github.com/hhanh00/zwallet/commit/$commitId"));
  }
}

class DisclaimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<DisclaimerPage> {
  List<bool> accepted = [false, false, false];
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.disclaimer)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset('assets/self-custody.png', fit: BoxFit.fill),
              Gap(16),
              Text(s.disclaimerText, style: t.textTheme.headlineMedium),
              Gap(16),
              DisclaimerItem(
                accepted[0],
                name: 'd1',
                text: s.disclaimer_1,
                onChanged: (v) => setState(() => accepted[0] = v!),
              ),
              Gap(16),
              DisclaimerItem(
                accepted[1],
                name: 'd2',
                text: s.disclaimer_2,
                onChanged: (v) => setState(() => accepted[1] = v!),
              ),
              Gap(16),
              DisclaimerItem(
                accepted[2],
                name: 'd3',
                text: s.disclaimer_3,
                onChanged: (v) => setState(() => accepted[2] = v!),
              ),
              Gap(16),
              OverflowBar(children: [
                IconButton.outlined(onPressed: allAccepted ? _accept : null, icon: Icon(Icons.check))
              ]),
            ],
          ),
        ),
      ),
    );
  }

  _accept() async {
    appSettings.disclaimer = true;
    await appSettings.save(await SharedPreferences.getInstance());
    GoRouter.of(context).push('/first_account');
  }

  bool get allAccepted => accepted.all((e) => e);
}

class DisclaimerItem extends StatelessWidget {
  final String name;
  final String text;
  final bool accepted;
  final void Function(bool?)? onChanged;
  DisclaimerItem(this.accepted,
      {super.key, required this.name, required this.text, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
                color: accepted ? Colors.green : Colors.red, width: 2)),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: FormBuilderCheckbox(
              name: name,
              title: Text(text, style: t.textTheme.headlineSmall),
              onChanged: onChanged,
            )));
  }
}
