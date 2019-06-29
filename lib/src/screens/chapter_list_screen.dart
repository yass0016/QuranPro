import 'package:quranpro/src/helpers/SQLiteHelper.dart';
import 'package:quranpro/src/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:quranpro/src/common/style.dart';

class ChapterListScreen extends StatefulWidget {
  ChapterListScreen();

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  // reference to our single class that manages the database
  final dbHelper = SQLiteHelper.instance;
  List<Chapter> _chapters;

  _ChapterListScreenState() {
    _getChapters();
  }

  void _getChapters() async {
    List<Chapter> chapters = await dbHelper.getChapters();

    setState(() {
      _chapters = chapters;
    });
  }

  void initState() {
    super.initState();

    setState(() {
      _chapters = new List<Chapter>();
    });
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int position) => Divider(
            height: 0.0,
          ),
          itemCount: _chapters.length,
          itemBuilder: (BuildContext context, int position) => ListTile(
                onTap: () {},
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_left, size: Style.iconSize(context, 20.0),)
                  ],
                ),
                subtitle: Container(
                  child:
                      Wrap(textDirection: TextDirection.rtl, children: <Widget>[
                    Text(
                      _chapters[position].ename,
                      style: TextStyle(
                          fontSize: Style.textSize(context, 16),
                          color: ThemeData().backgroundColor),
                    ),
                  ]),
                ),
                title: Container(
                  child:
                      Wrap(textDirection: TextDirection.rtl, children: <Widget>[
                    Text(
                      _chapters[position].name +
                          " (" +
                          _chapters[position].id +
                          ") ",
                      style: TextStyle(
                          fontSize: Style.textSize(context, 24),
                          color: ThemeData().backgroundColor),
                    ),
                  ]),
                ),
              ),
        ),
      ),
    );
  }
}
