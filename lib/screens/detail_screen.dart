import 'package:dictionary/Data/appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:share/share.dart';

class DetailScreen extends StatelessWidget {
  // For Share code
  void _shareContent() {
    final text =
        '${Get.find<appState>().word.value}\n\n${Get.find<appState>().definition.value}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.find<appState>().isDarkMode.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Obx(() => Text(
              Get.find<appState>().appBarTitle.value == "Khmer Dictionary"
                  ? "Definition"
                  : "និយមន័យ",
              style: TextStyle(
                fontFamily: KhmerFonts.moul,
                fontSize: 19,
                package: 'khmer_fonts',
                color: Colors.grey,
              ),
            )),
        actions: [
          Obx(
            () {
              final isBookmarked = Get.find<appState>().isBookmarked({
                'word': Get.find<appState>().word.value,
                'definition': Get.find<appState>().definition.value,
              });
              return IconButton(
                icon: Icon(
                  isBookmarked
                      ? Icons.favorite_sharp
                      : Icons.favorite_border_sharp,
                  color: Color.fromARGB(175, 255, 255, 255),
                ),
                onPressed: () {
                  Get.find<appState>().toggleBookmark({
                    'word': Get.find<appState>().word.value,
                    'definition': Get.find<appState>().definition.value,
                  });
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              _shareContent();
            },
            icon: Icon(Icons.ios_share),
            color: Color.fromARGB(175, 255, 255, 255),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: Get.find<appState>().word.value),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ពាក្យត្រូវបានចម្លង!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(Icons.copy),
            color: Color.fromARGB(175, 255, 255, 255),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              words(Get.find<appState>().word.value),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDarkMode ? Colors.black54 : Colors.white,
                      isDarkMode ? Colors.black54 : Colors.white,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        Get.find<appState>().word.value,
                        style: TextStyle(
                          fontFamily: KhmerFonts.bokor,
                          fontSize: 19,
                          package: 'khmer_fonts',
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                                text: Get.find<appState>().definition.value),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('និយមន័យត្រូវបានចម្លង!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: HtmlWidget(
                        Get.find<appState>().definition.value,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // Style of Words
  Container words(String var1) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(var1,
                  style: TextStyle(
                    fontFamily: KhmerFonts.bokor,
                    fontSize: 19,
                    package: 'khmer_fonts',
                    color: Colors.white,
                  )),
              SizedBox(height: 2),
            ],
          )
        ],
      ),
    );
  }
}
