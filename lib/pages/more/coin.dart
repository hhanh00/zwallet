import 'package:YWallet/accounts.dart';
import 'package:YWallet/appsettings.dart';
import 'package:YWallet/generated/intl/messages.dart';
import 'package:YWallet/tablelist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db.dart';
import '../../main.dart';
import '../../store.dart';

class CoinControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SortSetting(
      child: Scaffold(
        appBar: AppBar(title: Text(s.notes)),
        body: Observer(
          builder: (context) {
            active.notes;
            return TableListPage(
              view: appSettings.noteView,
              items: active.notes,
              metadata: TableListNoteMetadata(),
            );
          },
        ),
      ),
    );
  }
}

class TableListNoteMetadata extends TableListItemMetadata<Note> {
  @override
  List<Widget>? actions(BuildContext context) {
    return [
      IconButton(
          onPressed: inverseSelection, icon: Icon(MdiIcons.selectInverse)),
    ];
  }

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    final s = S.of(context);
    return [
      ColumnDefinition(field: 'height', label: s.height, numeric: true),
      ColumnDefinition(label: s.confs, numeric: true),
      ColumnDefinition(field: 'timestamp', label: s.datetime),
      ColumnDefinition(field: 'value', label: s.amount),
    ];
  }

  @override
  Text? header(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Text(
      s.selectNotesToExcludeFromPayments,
      style: t.textTheme.bodyMedium,
    );
  }

  @override
  Widget toListTile(BuildContext context, int index, Note note) {
    final s = S.of(context);
    final t = Theme.of(context);
    final excluded = note.excluded;
    final style = _noteStyle(t, note);
    final amountStyle = weightFromAmount(style, note.value);
    final nConfs = confirmations(note);
    final timestamp = humanizeDateTime(context, note.timestamp);
    return GestureDetector(
        onTap: () => _select(note),
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
            color: excluded
                ? t.primaryColor.withOpacity(0.5)
                : t.colorScheme.background,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  Column(children: [
                    Text("${note.height}", style: t.textTheme.bodySmall),
                    Text("$nConfs", style: t.textTheme.bodyMedium),
                  ]),
                  Expanded(
                      child: Center(
                          child: Text("${note.value}", style: amountStyle))),
                  Text("$timestamp"),
                ]))));
  }

  @override
  DataRow toRow(BuildContext context, int index, Note note) {
    final t = Theme.of(context);
    final style = _noteStyle(t, note);
    final amountStyle = weightFromAmount(style, note.value);
    final nConfs = confirmations(note);

    return DataRow.byIndex(
      index: index,
      selected: note.excluded,
      color: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? t.primaryColor.withOpacity(0.5)
              : t.colorScheme.background),
      cells: [
        DataCell(Text("${note.height}", style: style)),
        DataCell(Text("$nConfs", style: style)),
        DataCell(
            Text("${noteDateFormat.format(note.timestamp)}", style: style)),
        DataCell(Text(decimalFormat(note.value, 8), style: amountStyle)),
      ],
      onSelectChanged: (selected) => _select(note),
    );
  }

  @override
  void inverseSelection() {
    active.invertExcludedNotes();
    active.updatePoolBalances();
  }

  _select(Note note) {
    note.excluded = !note.excluded;
    active.excludeNote(note);
    active.updatePoolBalances();
  }

  TextStyle _noteStyle(ThemeData t, Note note) {
    var style = t.textTheme.bodyMedium!;
    if (confirmations(note) >= appSettings.anchorOffset)
      style = style.copyWith(color: style.color!.withOpacity(0.5));
    if (note.orchard) style = style.apply(color: t.primaryColor);
    return style;
  }

  int confirmations(Note note) => note.confirmations ?? -1;

  @override
  SortConfig2? sortBy(String field) {
    active.setNoteSortOrder(field);
    return active.noteOrder;
  }
}

class CoinControlPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.notes)),
      body: Observer(builder: (context) {
        active.notes;
        switch (appSettings.noteView) {
          case 0:
            return OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait)
                return NoteList();
              else
                return NoteTable();
            });
          case 1:
            return NoteTable();
          case 2:
            return NoteList();
        }
        throw 'Unreachable';
      }),
    );
  }
}

class NoteTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          active.notes;
          return PaginatedDataTable(
            columns: [
              DataColumn(
                label: Text(
                    s.height + (active.noteOrder?.indicator('height') ?? '')),
                onSort: (_, __) => active.setNoteSortOrder('height'),
              ),
              DataColumn(label: Text(s.confs)),
              DataColumn(
                label: Text(s.datetime +
                    (active.noteOrder?.indicator('timestamp') ?? '')),
                onSort: (_, __) => active.setNoteSortOrder('timestamp'),
              ),
              DataColumn(
                numeric: true,
                label: Text(
                    s.amount + (active.noteOrder?.indicator('value') ?? '')),
                onSort: (_, __) => active.setNoteSortOrder('value'),
              ),
            ],
            header: Text(s.selectNotesToExcludeFromPayments,
                style: t.textTheme.bodyMedium),
            actions: [
              IconButton(
                  onPressed: _selectInverse,
                  icon: Icon(MdiIcons.selectInverse)),
            ],
            columnSpacing: 16,
            showCheckboxColumn: false,
            availableRowsPerPage: [5, 10, 25, 100],
            onRowsPerPageChanged: (int? value) async {
              appSettings.rowsPerPage = value ?? 25;
              appSettings.save(await SharedPreferences.getInstance());
            },
            showFirstLastButtons: true,
            rowsPerPage: appSettings.rowsPerPage,
            source: NotesDataSource(context),
          );
        }));
  }

  _selectInverse() {
    active.invertExcludedNotes();
    active.updatePoolBalances();
  }
}

class NotesDataSource extends DataTableSource {
  final BuildContext context;
  NotesDataSource(this.context);

  @override
  DataRow getRow(int index) {
    final note = active.notes[index];
    final t = Theme.of(context);
    final confirmations = note.confirmations ?? -1;

    var style = t.textTheme.bodyMedium!;
    if (confirmations >= appSettings.anchorOffset)
      style = style.copyWith(color: style.color!.withOpacity(0.5));
    if (note.orchard) style = style.apply(color: t.primaryColor);

    final amountStyle = weightFromAmount(style, note.value);

    return DataRow.byIndex(
      index: index,
      selected: note.excluded,
      color: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? t.primaryColor.withOpacity(0.5)
              : t.colorScheme.background),
      cells: [
        DataCell(Text("${note.height}", style: style)),
        DataCell(Text("$confirmations", style: style)),
        DataCell(
            Text("${noteDateFormat.format(note.timestamp)}", style: style)),
        DataCell(Text(decimalFormat(note.value, 8), style: amountStyle)),
      ],
      onSelectChanged: (selected) => _noteSelected(note),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => active.notes.length;

  @override
  int get selectedRowCount => 0;

  void _noteSelected(Note note) {
    active.excludeNote(note);
    active.updatePoolBalances();
  }
}

class NoteList extends StatefulWidget {
  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    return Observer(builder: (context) {
      final notes = active.notes;
      return Padding(
        padding: EdgeInsets.all(16),
        child: CustomScrollView(
          key: UniqueKey(),
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                onTap: _onInvert,
                title: Text(s.selectNotesToExcludeFromPayments),
                trailing: Icon(Icons.select_all),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50,
              delegate: SliverChildBuilderDelegate((context, index) {
                return NoteItem(notes[index], index);
              }, childCount: notes.length),
            )
          ],
        ),
      );
    });
  }

  _onInvert() {
    active.invertExcludedNotes();
    active.updatePoolBalances();
  }

  @override
  bool get wantKeepAlive => true;
}

class NoteItem extends StatefulWidget {
  final Note note;
  final int index;
  NoteItem(this.note, this.index);

  @override
  NoteItemState createState() => NoteItemState();
}

class NoteItemState extends State<NoteItem> {
  var excluded = false;

  @override
  void initState() {
    super.initState();
    excluded = widget.note.excluded;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final note = widget.note;
    final timestamp = humanizeDateTime(context, note.timestamp);
    final confirmations = note.confirmations ?? -1;
    var style = t.textTheme.titleLarge!;
    if (confirmations >= appSettings.anchorOffset)
      style = style.merge(TextStyle(color: style.color!.withOpacity(0.5)));
    if (note.orchard) style = style.merge(TextStyle(color: t.primaryColor));

    final amountStyle = weightFromAmount(style, note.value);

    return GestureDetector(
        onTap: _onSelected,
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
            color: excluded
                ? t.primaryColor.withOpacity(0.5)
                : t.colorScheme.background,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  Column(children: [
                    Text("${note.height}", style: t.textTheme.bodySmall),
                    Text("$confirmations", style: t.textTheme.bodyMedium),
                  ]),
                  Expanded(
                      child: Center(
                          child: Text("${note.value}", style: amountStyle))),
                  Text("$timestamp"),
                ]))));
  }

  _onSelected() {
    setState(() {
      excluded = !excluded;
      widget.note.excluded = excluded;
      active.excludeNote(widget.note);
      active.updatePoolBalances();
    });
  }
}
