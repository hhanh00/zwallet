import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'appsettings.dart';
import 'generated/intl/messages.dart';
import 'pages/widgets.dart';

class ThemeEditorTab extends StatefulWidget {
  final void Function(Color primary, Color primaryAccent, Color secondary,
      Color secondaryAccent)? onSaved;
  ThemeEditorTab({this.onSaved});

  @override
  State<StatefulWidget> createState() => _ThemeEditorState();
}

class _ThemeEditorState extends State<ThemeEditorTab>
    with AutomaticKeepAliveClientMixin {
  late Color _primary = Color(appSettings.palette.primary);
  late Color _primaryVariant = Color(appSettings.palette.primaryVariant);
  late Color _secondary = Color(appSettings.palette.secondary);
  late Color _secondaryVariant = Color(appSettings.palette.secondaryVariant);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          Gap(8),
          Panel(s.primary,
              child: Column(children: [
                ListTile(
                  title: Text(s.color),
                  trailing: ColorSwatch(
                      _primary, (c) => setState(() => _primary = c)),
                ),
                ListTile(
                  title: Text(s.accentColor),
                  trailing: ColorSwatch(_primaryVariant,
                      (c) => setState(() => _primaryVariant = c)),
                ),
              ])),
          Gap(16),
          Panel(s.secondary,
              child: Column(children: [
                ListTile(
                  title: Text(s.color),
                  trailing: ColorSwatch(
                      _secondary, (c) => setState(() => _secondary = c)),
                ),
                ListTile(
                  title: Text(s.accentColor),
                  trailing: ColorSwatch(_secondaryVariant,
                      (c) => setState(() => _secondaryVariant = c)),
                ),
              ])),
        ]));
  }

  ok() {
    widget.onSaved
        ?.call(_primary, _primaryVariant, _secondary, _secondaryVariant);
    GoRouter.of(context).pop();
  }

  bool get wantKeepAlive => true;
}

class ColorSwatch extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;

  ColorSwatch(this.color, this.onColorChanged);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _openColorPicker(context),
        child: SizedBox(width: 32, height: 32, child: Container(color: color)));
  }

  _openColorPicker(BuildContext context) async {
    final s = S.of(context);
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(s.pickColor),
            content: SingleChildScrollView(
              child: ColorPicker(
                  pickerColor: color, onColorChanged: onColorChanged),
            )));
  }
}
