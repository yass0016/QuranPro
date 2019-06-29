import 'package:flutter/material.dart';
import 'package:quranpro/src/screens/chapter_list_screen.dart';
import 'package:quranpro/src/screens/juz_list_screen.dart';
import 'package:quranpro/src/common/style.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Sura List",
                    style: TextStyle(fontSize: Style.textSize(context, 18)),
                  ),
                ),
                Tab(
                  child: Text(
                    "Juz List",
                    style: TextStyle(fontSize: Style.textSize(context, 18)),
                  ),
                ),
              ],
            ),
            title: Text('Quran Pro'),
          ),
          body: TabBarView(
            children: [
              ChapterListScreen(),
              JuzListScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
