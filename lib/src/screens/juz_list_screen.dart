import 'package:quranpro/src/helpers/SQLiteHelper.dart';
import 'package:quranpro/src/models/juz.dart';
import 'package:flutter/material.dart';
import 'package:quranpro/src/common/style.dart';
import 'package:quranpro/src/screens/pages_screen.dart';

class JuzListScreen extends StatefulWidget {
  JuzListScreen();

  @override
  _JuzListScreenState createState() => _JuzListScreenState();
}

class _JuzListScreenState extends State<JuzListScreen> {
  // reference to our single class that manages the database
  final dbHelper = SQLiteHelper.instance;
  List<Juz> _juzs;

  _JuzListScreenState() {
    _getJuzs();
  }

  void _getJuzs() async {
    List<Juz> juzs = await dbHelper.getJuzs();

    setState(() {
      _juzs = juzs;
    });
  }

  void initState() {
    super.initState();

    setState(() {
      _juzs = new List<Juz>();
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
          itemCount: _juzs.length,
          itemBuilder: (BuildContext context, int position) => ListTile(
            onTap: () async {
              String page = await dbHelper.getPageFromJuz((position + 1).toString());
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
            isThreeLine: true,
            subtitle: Container(
              child:
              Wrap(textDirection: TextDirection.rtl, children: <Widget>[
                Text(
                  _juzs[position].tname,
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
                  _juzs[position].name +
                      " (" +
                      _juzs[position].id +
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
