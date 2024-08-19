import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class appState extends GetxController {
  var list = [].obs;
  var definition = "".obs;
  var word = "".obs;
  var showSnackBar = "".obs;
  var isDarkMode = false.obs;
  var hintText = 'ស្វែងរកពាក្យ...'.obs; // Add this line
  var appBarTitle = "វចនានុក្រមខ្មែរ".obs;
  var bookmarks = <Map<String, dynamic>>[].obs;
  var history = <Map<String, dynamic>>[].obs;
  var bottomNavLabels = ['កំណត់ត្រា', 'ស្វែងរក', 'ប្រវត្តិ'].obs;

  late Database database;

  get partOfSpeech => null;

  get englishPhonetic => null;

  get khmerPhonetic => null;

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'dictionary.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE IF NOT EXISTS history(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, definition TEXT)",
        );
        db.execute(
          "CREATE TABLE IF NOT EXISTS bookmarks(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, definition TEXT)",
        );
      },
      version: 1,
    );
    loadHistory();
    loadBookmarks();
  }

  Future<void> loadHistory() async {
    final List<Map<String, dynamic>> maps = await database.query('history');
    history.assignAll(maps);
  }

  Future<void> addHistory(Map<String, dynamic> item) async {
    await database.insert(
      'history',
      {
        'word': item['word'],
        'definition': item['definition'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    loadHistory();
  }

  Future<void> removeHistory(Map<String, dynamic> item) async {
    await database.delete(
      'history',
      where: "id = ?",
      whereArgs: [item['id']],
    );
    loadHistory();
  }

  Future<void> loadBookmarks() async {
    final List<Map<String, dynamic>> maps = await database.query('bookmarks');
    bookmarks.assignAll(maps);
  }

  Future<void> saveBookmark(Map<String, dynamic> item) async {
    await database.insert(
      'bookmarks',
      {
        'word': item['word'],
        'definition': item['definition'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    loadBookmarks();
  }

  Future<void> removeBookmark(Map<String, dynamic> item) async {
    await database.delete(
      'bookmarks',
      where: "word = ?",
      whereArgs: [item['word']],
    );
    loadBookmarks();
  }

  void toggleBookmark(Map<String, dynamic> item) {
    if (isBookmarked(item)) {
      removeBookmark(item);
    } else {
      saveBookmark(item);
    }
  }

  bool isBookmarked(Map<String, dynamic> item) {
    return bookmarks.any((bookmark) => bookmark['word'] == item['word']);
  }

  // Method to update app bar title
  void updateAppBarTitle(String newTitle) {
    appBarTitle.value = newTitle;
  }

  void updateHintText(String text) {
    hintText.value = text;
  }

  void updateBottomNavLabels(List<String> labels) {
    bottomNavLabels.value = labels;
  }

  void clearHistory() async {
    // Clear the in-memory list
    history.clear();
    // Clear the history from the database
    await database.delete('history');
  }

  void clearBookmark() async {
    // Clear the in-memory list
    bookmarks.clear();
    // Clear the history from the database
    await database.delete('bookmarks');
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
