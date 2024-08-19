import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dictionary/Data/appState.dart';
import 'package:dictionary/Data/db_utill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  TextEditingController _searchController = TextEditingController();
  String selectedLanguage = ''; // Default language
  List<Map<String, dynamic>> allWords = []; // Store all words initially

  @override
  void initState() {
    super.initState();
    fetchAllWords(); // Fetch all words from DB when the widget initializes
  }

  void fetchAllWords() async {
    DBUtil dbUtil = DBUtil();
    allWords = await dbUtil.select("SELECT * FROM Items");
    // Update the list with fetched words
    Get.find<appState>().list.value = List.from(allWords);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });

    if (language == 'English-Khmer') {
      Get.find<appState>().updateAppBarTitle("Khmer Dictionary");
      Get.find<appState>().updateHintText("Search for words...");
      Get.find<appState>()
          .updateBottomNavLabels(['Bookmarks', 'Search', 'History']);
    } else if (language == 'Khmer-Khmer') {
      Get.find<appState>().updateAppBarTitle("វចនានុក្រមខ្មែរ");
      Get.find<appState>().updateHintText("ស្វែងរកពាក្យ...");
      Get.find<appState>()
          .updateBottomNavLabels(['កំណត់ត្រា', 'ស្វែងរក', 'ប្រវត្តិ']);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'Change Language',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'English',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  _changeLanguage('English-Khmer');
                  Navigator.of(context).pop();
                },
                selected: selectedLanguage == 'English-Khmer',
              ),
              ListTile(
                title: Text(
                  'Khmer',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  _changeLanguage('Khmer-Khmer');
                  Navigator.of(context).pop();
                },
                selected: selectedLanguage == 'Khmer-Khmer',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          onPressed: _showLanguageDialog,
          icon: Icon(
            Icons.font_download_outlined,
            color: Colors.grey,
          ),
        ),
        title: Obx(() => Text(
              Get.find<appState>().appBarTitle.value,
              style: TextStyle(
                fontFamily: KhmerFonts.moul,
                fontSize: 19,
                package: 'khmer_fonts',
                color: Colors.grey,
              ),
            )),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<appState>().toggleTheme();
            },
            icon: Icon(
              Get.find<appState>().isDarkMode.value
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Color.fromARGB(255, 208, 157, 3),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
            child: Obx(() => TextField(
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      // If search text is empty, show all words
                      Get.find<appState>().list.value = List.from(allWords);
                    } else {
                      // Perform search and update the list accordingly
                      DBUtil dbUtil = DBUtil();
                      Get.find<appState>().list.value = await dbUtil.select(
                        "SELECT * FROM Items WHERE word LIKE '${value}%'",
                      );
                    }
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: Get.find<appState>().hintText.value,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        Get.find<appState>().list.value = List.from(allWords);
                      },
                      icon: Icon(
                        Icons.clear,
                      ),
                    ),
                    filled: true,
                    fillColor: Get.find<appState>().isDarkMode.value
                        ? Colors.black54
                        : Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () {
                var searchResults = Get.find<appState>().list;
                if (searchResults.isEmpty) {
                  return Center(
                    child: Obx(
                      () => Text(
                        Get.find<appState>().appBarTitle.value ==
                                "Khmer Dictionary"
                            ? "Word can't be found"
                            : "មិនមានពាក្យ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Get.find<appState>().isDarkMode.value
                              ? Colors.grey
                              : Colors.black54,
                        ),
                      ),
                    ),
                  );
                }
                return AnimationLimiter(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var wordData = searchResults[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 275),
                        child: SlideAnimation(
                          verticalOffset:
                              50.0, // Change to -50.0 for fade-in effect
                          child: FadeInAnimation(
                            child: ListText(
                              wordData,
                              Get.find<appState>().isBookmarked(wordData)
                                  ? Icon(
                                      Icons.bookmark,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.bookmark_border),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container ListText(wordData, Icon bookmarkIcon) {
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
          Get.find<appState>().word.value = wordData["word"];
          Get.find<appState>().definition.value = wordData["definition"];
          Get.find<appState>().addHistory({
            'word': wordData["word"],
            'definition': wordData["definition"],
          });
          Navigator.pushNamed(context, '/DetailScreen');
        },
        title: Text(
          wordData["word"],
          style: TextStyle(fontSize: 19),
        ),
        trailing: Obx(() {
          var isDarkMode = Get.find<appState>().isDarkMode.value;
          return Icon(
            Icons.arrow_forward_ios,
            color: isDarkMode ? Colors.grey : Colors.black54,
            size: 14,
          );
        }),
      ),
    );
  }
}
