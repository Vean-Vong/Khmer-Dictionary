import 'package:dictionary/Data/appState.dart';
import 'package:dictionary/Data/db_utill.dart';
import 'package:dictionary/screens/NavigationBar.dart';
import 'package:dictionary/screens/bookmark.dart';
import 'package:dictionary/screens/detail_screen.dart';
import 'package:dictionary/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {               
  Get.put(appState());

  // Copy database Object
  DBUtil dbUtil = DBUtil();

  // Query database and add it to the list appState
  Get.find<appState>().list.value =
      await dbUtil.select("SELECT * FROM Items LIMIT 100");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isDarkMode = Get.find<appState>().isDarkMode.value;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => page(),
          '/Homepage': (context) => Homepage(),
          '/DetailScreen': (context) => DetailScreen(),
          '/Bookmark': (context) => Bookmark(),
        },
      );
    });
  }
}
