import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'main.dart';
import 'store.dart';
import 'db.dart';
import 'generated/l10n.dart';

class NoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (settings.noteTable)
        return NoteWidgetTable();
      else
        return NoteWidgetList();
    });
  }
}

class NoteWidgetTable extends StatefulWidget {
  NoteWidgetTable();

  @override
  State<StatefulWidget> createState() => _NoteState();
}

class _NoteState extends State<NoteWidgetTable> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          final _1 = active.sortedNotes;
          return PaginatedDataTable(
            columns: [
              DataColumn(
                  label: settings.showConfirmations
                      ? Text(S.of(context).confs)
                      : Text(S.of(context).height),
                  onSort: (_, __) {
                    setState(() {
                      settings.toggleShowConfirmations();
                    });
                  }),
              DataColumn(
                label: Text(S.of(context).datetime +
                    active.noteSortConfig.getIndicator("time")),
                onSort: (_, __) {
                  setState(() {
                    active.sortNotes("time");
                  });
                },
              ),
              DataColumn(
                numeric: true,
                label: Text(S.of(context).amount +
                    active.noteSortConfig.getIndicator("amount")),
                onSort: (_, __) {
                  setState(() {
                    active.sortNotes("amount");
                  });
                },
              ),
            ],
            header: Text(S.of(context).selectNotesToExcludeFromPayments,
                style: Theme.of(context).textTheme.bodyText2),
            actions: [
              IconButton(onPressed: _selectInverse, icon: Icon(MdiIcons.selectInverse)),
            ],
            columnSpacing: 16,
            showCheckboxColumn: false,
            availableRowsPerPage: [5, 10, 25, 100],
            onRowsPerPageChanged: (int? value) {
              settings.setRowsPerPage(value ?? 25);
            },
            showFirstLastButtons: true,
            rowsPerPage: settings.rowsPerPage,
            source: NotesDataSource(context, _onRowSelected),
          );
        }));
  }

  _onRowSelected(Note note) {
    active.excludeNote(note);
  }

  _selectInverse() {
    active.invertExcludedNotes();
  }
}

class NotesDataSource extends DataTableSource {
  final BuildContext context;
  final Function(Note) onRowSelected;

  NotesDataSource(this.context, this.onRowSelected);

  @override
  DataRow getRow(int index) {
    final note = active.sortedNotes[index];
    final theme = Theme.of(context);
    final confsOrHeight = settings.showConfirmations
        ? syncStatus.latestHeight - note.height + 1
        : note.height;

    var style = theme.textTheme.bodyText2!;
    if (!confirmed(note.height))
      style = style.copyWith(color: style.color!.withOpacity(0.5));

    if (note.spent)
      style = style.merge(TextStyle(decoration: TextDecoration.lineThrough));

    final amountStyle = weightFromAmount(style, note.value);

    return DataRow.byIndex(
      index: index,
      selected: note.excluded,
      color: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? theme.primaryColor.withOpacity(0.5)
              : theme.backgroundColor),
      cells: [
        DataCell(Text("$confsOrHeight", style: style)),
        DataCell(Text("${noteDateFormat.format(note.timestamp)}", style: style)),
        DataCell(Text(decimalFormat(note.value, 8), style: amountStyle)),
      ],
      onSelectChanged: (selected) => _noteSelected(note, selected),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => active.notes.length;

  @override
  int get selectedRowCount => 0;

  void _noteSelected(Note note, bool? selected) {
    note.excluded = !note.excluded;
    notifyListeners();
    onRowSelected(note);
  }
}

class NoteWidgetList extends StatefulWidget {
  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteWidgetList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Observer(builder: (context) {
      final notes = active.sortedNotes;
      return Padding(padding: EdgeInsets.all(16), child: CustomScrollView(
        key: UniqueKey(),
        slivers: [
          SliverToBoxAdapter(child: ListTile(
            onTap: _onInvert,
            title: Text(s.selectNotesToExcludeFromPayments),
            trailing: Icon(Icons.select_all),
          )),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildBuilderDelegate((context, index) {
              return NoteItem(notes[index], index);
            }, childCount: notes.length))
        ],
      ));
    });
  }

  _onInvert() {
    active.invertExcludedNotes();
  }
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
    final theme = Theme.of(context);
    final note = widget.note;
    final timestamp = humanizeDateTime(note.timestamp);
    final confirmations = syncStatus.latestHeight - note.height + 1;
    var style = theme.textTheme.titleLarge!;
    if (!confirmed(note.height))
      style = style.merge(TextStyle(color: style.color!.withOpacity(0.5)));
    if (note.spent)
      style = style.merge(TextStyle(decoration: TextDecoration.lineThrough));

    final amountStyle = weightFromAmount(style, note.value);

    return GestureDetector(onTap: _onSelected, behavior: HitTestBehavior.opaque, child:
      ColoredBox(color: excluded ? theme.primaryColor.withOpacity(0.5) : theme.backgroundColor, child:
        Padding(padding: EdgeInsets.all(8), child:
          Row(children: [
            Column(children: [Text("${note.height}", style: theme.textTheme.bodySmall),
              Text("${confirmations}", style: theme.textTheme.bodyMedium),
            ]),
            Expanded(child: Center(child: Text("${note.value}", style: amountStyle))),
            Text("${timestamp}"),
      ]))));
  }

  _onSelected() {
    setState(() {
      excluded = !excluded;
      widget.note.excluded = excluded;
      active.excludeNote(widget.note);
    });
  }
}

bool confirmed(int height) {
  return syncStatus.latestHeight - height >= settings.anchorOffset;
}

