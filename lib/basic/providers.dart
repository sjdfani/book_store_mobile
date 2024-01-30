import 'package:book_store_mobile/basic/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifier with ChangeNotifier {
  String _theme = 'light';
  ThemeData _themeData = ThemeData.light();
  double _fontSize = 20.0;

  ThemeData get themeData => _themeData;
  String get theme => _theme;
  void setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", theme);
    _theme = theme;
    if (theme == "light") {
      _themeData = customLightTheme;
    } else if (theme == "blue") {
      _themeData = customBlueTheme;
    } else {
      _themeData = customDarkTheme;
    }
    notifyListeners();
  }

  double get fontSize => _fontSize;
  void setFont(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', fontSize);
    _fontSize = fontSize;
    notifyListeners();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 20.0;
    setFont(_fontSize);
    var theme = prefs.getString('theme') ?? 'light';
    setTheme(theme);
  }
}

class UserInfoNotifier with ChangeNotifier {
  int _userid = 0;
  String _fullname = "";
  String _accesstoken = "";
  bool _superuser = false;
  bool _logined = false;

  int get userid => _userid;
  String get fullname => _fullname;
  String get accesstoken => _accesstoken;
  bool get superuser => _superuser;
  bool get logined => _logined;

  Future<void> loginProcess(
      int userid, String fullname, String accesstoken, bool superuser) async {
    _userid = userid;
    _fullname = fullname;
    _accesstoken = accesstoken;
    _superuser = superuser;
    _logined = true;
    notifyListeners();
  }

  Future<void> logoutProcess() async {
    _userid = 0;
    _fullname = "";
    _accesstoken = "";
    _superuser = false;
    _logined = false;
    notifyListeners();
  }
}

class BookStoreNotifier with ChangeNotifier {
  List<int> _savedItems = [];
  List<int> _shppingItems = [];
  bool _hasSavedItemsData = false;
  bool _hasShoppingItemsData = false;

  List<int> get savedItems => _savedItems;
  List<int> get shoppingItems => _shppingItems;
  bool get hasSavedItemsData => _hasSavedItemsData;
  bool get hasShoppingItemsData => _hasShoppingItemsData;

  void addSavedItem(int bookId) {
    _savedItems.add(bookId);
    _hasSavedItemsData = true;
    notifyListeners();
  }

  void removeSavedItem(int bookId) {
    _savedItems.remove(bookId);
    if (_savedItems.isEmpty) {
      _hasSavedItemsData = false;
    }
    notifyListeners();
  }

  void setSavedItem(List<int> saveId) {
    _savedItems = saveId;
    if (_savedItems.isNotEmpty) {
      _hasSavedItemsData = true;
    }
    notifyListeners();
  }

  void addShoppingItem(int bookId) {
    _shppingItems.add(bookId);
    _hasShoppingItemsData = true;
    notifyListeners();
  }

  void removeShoppingItem(int bookId) {
    _shppingItems.remove(bookId);
    if (_shppingItems.isEmpty) {
      _hasShoppingItemsData = false;
    }
    notifyListeners();
  }

  void setShoppingItem(List<int> shppingList) {
    _shppingItems = shppingList;
    if (_shppingItems.isNotEmpty) {
      _hasShoppingItemsData = true;
    }
    notifyListeners();
  }
}
