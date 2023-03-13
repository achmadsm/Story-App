import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = 'state';
  final String userKey = 'user';

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, false);
  }

  Future saveUser(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(userKey, token);
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(userKey, '');
  }

  Future<String?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(userKey);
  }
}
