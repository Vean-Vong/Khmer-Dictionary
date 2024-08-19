import 'package:dictionary/Data/appState.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Bookmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Bookmarked"
                  : "កំណត់ត្រា",
              style: TextStyle(
                fontFamily: KhmerFonts.moul,
                fontSize: 19,
                package: 'khmer_fonts',
                color: Colors.grey,
              ),
            )),
        actions: [
          GestureDetector(
            onTap: () => _confirmClearBookmark(context),
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
        final bookmarks = Get.find<appState>().bookmarks;
        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_sharp,
                  size: 35,
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
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmarkData = bookmarks[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 275),
                  child: SlideAnimation(
                    horizontalOffset:
                        -50.0, // Change to -50.0 for fade-left effect
                    child: FadeInAnimation(
                      child: Words(bookmarkData, context),
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

  Container Words(Map<String, dynamic> Str, BuildContext context) {
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
          Get.find<appState>().word.value = Str["word"];
          Get.find<appState>().definition.value = Str["definition"];
          Navigator.pushNamed(context, '/DetailScreen');
        },
        leading: IconButton(
          icon: Obx(() => Icon(
                Get.find<appState>().isBookmarked(Str)
                    ? Icons.favorite_sharp
                    : Icons.favorite_border_sharp,
                color: Get.find<appState>().isDarkMode.value
                    ? Colors.grey
                    : Colors.black54,
                size: 18,
              )),
          onPressed: () {
            Get.find<appState>().toggleBookmark(Str);
          },
        ),
        title: Text(
          Str["word"],
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Get.find<appState>().isDarkMode.value
              ? Colors.grey
              : Colors.black54,
          size: 15,
        ),
      ),
    );
  }

  // Method for alert to clear the bookmarks
  void _confirmClearBookmark(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Clear Bookmarks"
                  : "លុបកំណត់ត្រា",
              style: TextStyle(
                fontFamily: KhmerFonts.moul,
                fontSize: 15,
                package: 'khmer_fonts',
                color: Colors.black,
              ),
            )),
        content: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Are you sure you want to clear all bookmarks?"
                  : "តើអ្នកចង់លុបកំណត់ត្រាទាំងអស់?",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Obx(
              () => Text(
                Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                    ? "Cancel"
                    : "អត់ទេ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.find<appState>().clearBookmark();
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
