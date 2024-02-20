import 'accounts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appsettings.dart';
import 'pages/utils.dart';

class SortSetting extends InheritedWidget {
  final config = ValueNotifier<SortConfig2?>(null);
  SortSetting({super.key, required super.child});

  static SortSetting? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SortSetting>();
  }

  @override
  bool updateShouldNotify(SortSetting oldWidget) =>
      config.value != oldWidget.config.value;
}

class TableListPage<U, T extends TableListItemMetadata<U>>
    extends StatelessWidget {
  final Key? listKey;
  final int view;
  final T metadata;
  final List<U> items;
  final EdgeInsets? padding;

  TableListPage({
    Key? key,
    this.listKey,
    required this.view,
    required this.items,
    required this.metadata,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inner = () {
      switch (view) {
        case 0:
          return _TableView(items, metadata);
        case 1:
          return _ListView(items, metadata, key: listKey);
        case 2:
          return OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait)
              return _ListView(items, metadata);
            else
              return _TableView(items, metadata);
          });
      }
      throw 'Unreachable';
    } ();
    return padding != null ? Padding(padding: padding!, child: inner) : inner;
  }
}

abstract class TableListItemMetadata<T> {
  Text? headerText(BuildContext context);
  Widget? header(BuildContext context);
  List<Widget>? actions(BuildContext context);
  List<ColumnDefinition> columns(BuildContext context);
  Widget toListTile(BuildContext context, int index, T item,
      {void Function(void Function())? setState});
  DataRow toRow(BuildContext context, int index, T item);
  void inverseSelection();
  SortConfig2? sortBy(String field);
}

class ColumnDefinition {
  final String label;
  final String? field;
  final bool numeric;
  ColumnDefinition({
    required this.label,
    this.field,
    this.numeric = false,
  });
}

class _TableView<U, T extends TableListItemMetadata<U>> extends StatefulWidget {
  final List<U> items;
  final T metadata;
  _TableView(this.items, this.metadata);

  @override
  State<StatefulWidget> createState() => TableViewState<U, T>();
}

class TableViewState<U, T extends TableListItemMetadata<U>>
    extends State<_TableView<U, T>> {
  @override
  Widget build(BuildContext context) {
    final sort = SortSetting.of(context)?.config.value;
    final columns = widget.metadata
        .columns(context)
        .map((c) => DataColumn(
              label: Text(
                  c.label + (c.field?.let((f) => sort?.indicator(f)) ?? '')),
              onSort: c.field?.let((f) => (_, __) {
                    SortSetting.of(context)?.config.value =
                        widget.metadata.sortBy(f);
                  }),
            ))
        .toList();

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: LayoutBuilder(
            builder: (context, box) => SizedBox(
                  width: box.maxWidth,
                  child: PaginatedDataTable(
                    columns: columns,
                    header: widget.metadata.headerText(context),
                    actions: widget.metadata.actions(context),
                    columnSpacing: 16,
                    showCheckboxColumn: false,
                    availableRowsPerPage: [5, 10, 25, 100],
                    onRowsPerPageChanged: (int? value) async {
                      appSettings.rowsPerPage = value ?? 25;
                      appSettings.save(await SharedPreferences.getInstance());
                    },
                    showFirstLastButtons: true,
                    rowsPerPage: appSettings.rowsPerPage,
                    source: _DataSource(context, widget.items, widget.metadata),
                  ),
                )));
  }
}

class _DataSource<U, T extends TableListItemMetadata<U>>
    extends DataTableSource {
  final BuildContext context;
  List<U> items;
  T metadata;

  _DataSource(this.context, this.items, this.metadata);

  @override
  DataRow getRow(int index) {
    return metadata.toRow(context, index, items[index]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

class _ListView<U, T extends TableListItemMetadata<U>> extends StatefulWidget {
  final List<U> items;
  final T metadata;
  _ListView(this.items, this.metadata, {super.key});

  @override
  State<StatefulWidget> createState() => ListViewState<U, T>();
}

class ListViewState<U, T extends TableListItemMetadata<U>>
    extends State<_ListView<U, T>> {
  @override
  Widget build(BuildContext context) {
    final headerText = widget.metadata.headerText(context);
    final Widget? headerTextWidget = headerText?.let((h) => ListTile(
          onTap: _onInvert,
          title: h,
          trailing: Icon(Icons.select_all),
        ));
    final header = headerTextWidget ?? widget.metadata.header(context);
    return CustomScrollView(
      key: widget.key,
      semanticChildCount: widget.items.length,
      slivers: [
        if (header != null)
          SliverToBoxAdapter(
            child: header,
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => index.isEven
                ? widget.metadata.toListTile(
                    context, index ~/ 2, widget.items[index ~/ 2],
                    setState: setState)
                : Divider(),
            childCount: widget.items.length * 2 - 1,
            semanticIndexCallback: (Widget widget, int index) =>
                index.isEven ? index ~/ 2 : null,
          ),
        )
      ],
    );
  }

  _onInvert() {
    widget.metadata.inverseSelection();
  }
}
