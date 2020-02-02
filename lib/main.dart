import 'package:flutter/material.dart';
import 'package:quranpro/src/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String quranStyle = prefs.getString("quranStyle");


  if(quranStyle == null) {
    await prefs.setString('quranStyle', "quran_simple");
  }

  return runApp(App());
}
