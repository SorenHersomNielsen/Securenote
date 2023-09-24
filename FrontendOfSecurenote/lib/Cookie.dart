import 'package:shared_preferences/shared_preferences.dart';

class Cookie {
  Future<void> setCookie(String user_id, String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(user_id, value);
  }

  Future<String?> readCookie(String user_id) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(user_id);
  }
}
