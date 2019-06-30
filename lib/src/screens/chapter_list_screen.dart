import 'package:quranpro/src/helpers/SQLiteHelper.dart';
import 'package:quranpro/src/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:quranpro/src/common/style.dart';
import 'package:quranpro/src/screens/pages_screen.dart';

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
                onTap: () async {
                  String page = await dbHelper.getPageFromChapter(_chapters[position].id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagesScreen(page: page),
                    ),
                  );
                },
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_left)
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
