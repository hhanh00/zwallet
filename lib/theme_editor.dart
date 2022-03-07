import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'main.dart';

import 'generated/l10n.dart';

typedef OnThemeSaved(Color primary, Color primaryAccent, Color secondary, Color secondaryAccent);

class ThemeEditorPage extends StatefulWidget {
  final OnThemeSaved? onSaved;

  ThemeEditorPage({this.onSaved});
  ThemeEditorState createState() => ThemeEditorState();
}

class ThemeEditorState extends State<ThemeEditorPage> {
  Color _primary = Colors.black;
  Color _primaryVariant = Colors.black;
  Color _secondary = Colors.black;
  Color _secondaryVariant = Colors.black;

  @override
  void initState() {
    super.initState();

    _primary = Color(settings.primaryColorValue);
    _primaryVariant = Color(settings.primaryVariantColorValue);
    _secondary = Color(settings.secondaryColorValue);
    _secondaryVariant = Color(settings.secondaryVariantColorValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.themeEditor)),
        body: Padding(padding: EdgeInsets.all(8), child: Form(
          child: Column(children: [
            Text(s.primary, style: theme.textTheme.headline6),
            Padding(padding: EdgeInsets.all(4)),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.dividerColor, width: 1)
              ),
              child: Column(children: [
                ListTile(title: Text(s.color), trailing: ColorSwatch(_primary, (c) => setState(() { _primary = c; }))),
                ListTile(title: Text(s.accentColor), trailing: ColorSwatch(_primaryVariant, (c) => setState(() { _primaryVariant = c; }))),
            ])),
            Padding(padding: EdgeInsets.all(8)),
            Text(s.secondary, style: theme.textTheme.headline6),
            Padding(padding: EdgeInsets.all(4)),
            Card(
                child: Column(children: [
                  ListTile(title: Text(s.color), trailing: ColorSwatch(_secondary, (c) => setState(() { _secondary = c; }))),
                  ListTile(title: Text(s.accentColor), trailing: ColorSwatch(_secondaryVariant, (c) => setState(() { _secondaryVariant = c; }))),
                ])),
            ButtonBar(children: confirmButtons(context, _ok))
        ]))));
  }

  _ok() {
    widget.onSaved?.call(_primary, _primaryVariant, _secondary, _secondaryVariant);
    Navigator.of(context).pop();
  }
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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: onColorChanged, showLabel: true),
      ))
    );
  }
}