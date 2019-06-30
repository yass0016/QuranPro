import 'package:quranpro/src/helpers/SQLiteHelper.dart';
import 'package:quranpro/src/models/juz.dart';
import 'package:flutter/material.dart';
import 'package:quranpro/src/common/style.dart';
import 'package:quranpro/src/models/list_item.dart';
import 'package:quranpro/src/models/chapter.dart';

class PageListScreen extends StatefulWidget {
  final String page;

  PageListScreen({Key key, @required this.page}) : super(key: key);

  @override
  _PageListScreenState createState() => _PageListScreenState(page);
}

class _PageListScreenState extends State<PageListScreen> {
  // reference to our single class that manages the database
  final dbHelper = SQLiteHelper.instance;
  List _items;

  _PageListScreenState(String page) {
    _buildItems(page);
  }

  void _buildItems(String page) async {
    List items = [];

    var query = await dbHelper.getVersesInPage(page);

    query.forEach((row) async {
      Chapter chapter = await dbHelper.getChapterInfo(row['sura'].toString());

      if (row['aya'].toString() == "1" && row['new_juz'].toString() == "1") {
        items.addAll([
          new ChapterHeaderItem(chapter.name, chapter.id),
          new JuzHeaderItem(row['juz'].toString()),
          new VerseItem(row['text'], row['aya'].toString())
        ]);
      } else if (row['aya'].toString() == "1") {
        items.addAll([
          new ChapterHeaderItem(chapter.name, chapter.id),
          new VerseItem(row['text'], row['aya'].toString())
        ]);
      } else if (row['new_juz'].toString() == "1") {
        items.addAll([
          new JuzHeaderItem(row['juz'].toString()),
          new VerseItem(row['text'], row['aya'].toString())
        ]);
      } else {
        items.add(new VerseItem(row['text'], row['aya'].toString()));
      }

      setState(() {
        _items = items;
      });
    });
  }

  void initState() {
    super.initState();

    setState(() {
      _items = List<ListItem>();
    });
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int position) => Divider(
                  height: 0.0,
                ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];

              if (item is ChapterHeaderItem) {
                return Container(
                  color: ThemeData.dark().primaryColor,
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: FittedBox(
                    child: Text(
                      item.name + " (" + item.number + ")",
                      style: TextStyle(
                          fontSize: Style.textSize(context, 24),
                          color: ThemeData().backgroundColor),
                    ),
                  ),
                );
              } else if (item is JuzHeaderItem) {
                return Container(
                  color: Color.fromARGB(255, 0, 0, 255),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: FittedBox(
                    child: Text(
                      "Juz " + item.number,
                      style: TextStyle(
                          fontSize: Style.textSize(context, 24),
                          color: ThemeData().backgroundColor),
                    ),
                  ),
                );
              } else if (item is VerseItem) {
                return ListTile(
                  title: Container(
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        runAlignment: WrapAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Text(
                            item.verse + " {" + item.verseNumber + "} ",
                            style: TextStyle(
                                fontSize: Style.textSize(context, 24),
                                color: ThemeData().backgroundColor),
                            textAlign: TextAlign.right,
                          ),
                        ]),
                  ),
                );
              }
            },
          ),
        ),
        Container(
          color: Color.fromARGB(255, 0, 0, 0),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: FittedBox(
            child: Text(
              "Page " + widget.page,
              style: TextStyle(
                  fontSize: Style.textSize(context, 24),
                  color: ThemeData().backgroundColor),
            ),
          ),
        )
      ],
    ));
  }
}
