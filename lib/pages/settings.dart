import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protobuf/protobuf.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart';
import '../main.dart';
import '../settings.pb.dart';

late AppSettings settings;

class SettingsPage extends StatefulWidget {
  final int coin;
  SettingsPage({required this.coin});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormBuilderState>();
  late final tabController = TabController(length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
    settings = appSettings.deepCopy();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = coins[widget.coin];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
        bottom: TabBar(controller: tabController, isScrollable: true, tabs: [
          Tab(text: 'General'),
          Tab(text: 'Privacy'),
          Tab(text: 'Views'),
          Tab(text: c.name),
        ]),
        actions: [
          ElevatedButton.icon(
            onPressed: _ok,
            icon: Icon(Icons.check),
            label: Text(s.ok),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: TabBarView(
          controller: tabController,
          children: [
            GeneralTab(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  _ok() async {
    final prefs = await SharedPreferences.getInstance();
    await settings.save(prefs);
    loadAppSettings(prefs);
    GoRouter.of(context).pop();
  }
}

class GeneralTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneralState();
}

class _GeneralState extends State<GeneralTab> {
  bool advanced = settings.advanced;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderSwitch(
      name: 'mode',
      title: Text(s.mode),
      initialValue: advanced,
      onChanged: _mode,
    );
  }

  _mode(bool? v) {
    if (v == null) return;
    setState(() {
      advanced = v;
      settings.advanced = v;
    });
  }
}
