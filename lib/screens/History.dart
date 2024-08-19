import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:dictionary/Data/appState.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Obx(
          () => Text(
            Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                ? "History"
                : "ប្រវត្តិស្វែងរក",
            style: TextStyle(
              fontFamily: KhmerFonts.moul,
              fontSize: 19,
              package: 'khmer_fonts',
              color: Colors.grey,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _confirmClearHistory(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Obx(
                  () => Text(
                    Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                        ? "Clear All"
                        : "លុបទាំងអស់",
                    style: TextStyle(
                      fontSize: 15,
                      package: 'khmer_fonts',
                      color: Color.fromARGB(255, 227, 173, 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final history = Get.find<appState>().history;
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 40,
                  color: Colors.black54,
                ),
                SizedBox(height: 10),
                Text(
                  Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                      ? "No data available"
                      : "មិនមានទិន្នន័យ",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        } else {
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final historyData = history[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 275),
                  child: SlideAnimation(
                    horizontalOffset:
                        50.0, // Change to -50.0 for fade-right effect
                    child: FadeInAnimation(
                      child: HistoryItem(historyData: historyData),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  // Method for alert to clear the history
  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Clear History"
                  : "លុបការចងចាំ",
              style: TextStyle(
                fontFamily: KhmerFonts.moul,
                fontSize: 15,
                package: 'khmer_fonts',
                color: Colors.black,
              ),
            )),
        content: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Are you sure you want to clear all history?"
                  : "តើអ្នកចង់លុបការចងចាំទាំងអស់?",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Obx(() => Text(
                  Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                      ? "Cancel"
                      : "អត់ទេ",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Get.find<appState>().clearHistory();
              Navigator.of(context).pop();
            },
            child: Obx(() => Text(
                  Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                      ? "Clear"
                      : "លុប",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final Map<String, dynamic> historyData;

  HistoryItem({required this.historyData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.find<appState>().isDarkMode.value
                ? Colors.black54
                : Colors.white,
            Get.find<appState>().isDarkMode.value
                ? Colors.black54
                : Colors.white,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Get.find<appState>().word.value = historyData["word"];
          Get.find<appState>().definition.value = historyData["definition"];
          Navigator.pushNamed(context, '/DetailScreen');
        },
        leading: Icon(
          Icons.history,
          color: Get.find<appState>().isDarkMode.value
              ? Colors.grey
              : Colors.black54,
          size: 17,
        ),
        title: Text(
          historyData["word"],
          style: TextStyle(fontSize: 19),
        ),
        trailing: IconButton(
          onPressed: () {
            Get.find<appState>().removeHistory(historyData);
          },
          icon: Icon(Icons.delete, color: Colors.red, size: 17),
        ),
      ),
    );
  }
}
