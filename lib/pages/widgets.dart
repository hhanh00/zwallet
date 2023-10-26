import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final String title;
  final String? text;
  final Widget? child;
  Panel(this.title, {this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration:
            InputDecoration(label: Text(title), border: OutlineInputBorder()),
        child: text != null ? SelectableText(text!) : child);
  }
}
