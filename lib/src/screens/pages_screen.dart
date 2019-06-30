import 'package:flutter/material.dart';
import 'package:quranpro/src/common/style.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:quranpro/src/screens/page_list_screen.dart';

class PagesScreen extends StatefulWidget {
  final String page;

  PagesScreen({Key key, @required this.page}) : super(key: key);

  @override
  _PagesScreenState createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {

  _PagesScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Pro'),
      ),
      body: new Swiper(
        loop: false,
        index: (604 - int.parse(widget.page)),
        itemBuilder: (BuildContext context, int index) {
          return PageListScreen(page: (((index - 604) * -1)).toString());
        },
        itemCount: 604,
      ),
    );
  }
}