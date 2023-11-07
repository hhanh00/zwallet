import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mustache_template/mustache.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/intl/messages.dart';
import '../../src/version.dart';
import '../utils.dart';

class AboutPage extends StatelessWidget {
  final String contentTemplate;
  AboutPage(this.contentTemplate);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final template = Template(contentTemplate);
    var content = template.renderString({'APP': APP_NAME});
    final id = commitId.substring(0, 8);
    final versionString = "${s.version}: $packageVersion/$id";
    return Scaffold(
      appBar: AppBar(title: Text(s.about)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MarkdownBody(data: content),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            TextButton(
                child: Text(versionString),
                onPressed: () => openGithub(commitId)),
          ],
        ),
      ),
    );
  }

  openGithub(String commitId) {
    launchUrl(Uri.parse("https://github.com/hhanh00/zwallet/commit/$commitId"));
  }
}
