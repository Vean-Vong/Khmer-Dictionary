import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dictionary/Data/appState.dart';
import 'package:dictionary/screens/History.dart';
import 'package:dictionary/screens/bookmark.dart';
import 'package:dictionary/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<page> {
  int _page = 1;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildNavItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 30,
          color: color,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: [
          Bookmark(),
          Homepage(),
          HistoryPage(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        var labels = Get.find<appState>().bottomNavLabels;
        var isDarkMode = Get.find<appState>().isDarkMode.value;
        var color = isDarkMode ? Colors.white : Colors.grey;
        var backgroundColor = isDarkMode ? Colors.black87 : Colors.white;

        return CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          items: [
            buildNavItem(Icons.menu_book, labels[0], color),
            buildNavItem(Icons.search, labels[1], color),
            buildNavItem(Icons.history, labels[2], color),
          ],
          color: backgroundColor,
          buttonBackgroundColor: backgroundColor,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 130),
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          letIndexChange: (index) => true,
        );
      }),
    );
  }
}
