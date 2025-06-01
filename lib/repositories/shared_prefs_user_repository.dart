import 'package:lab_1/repositories/user_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_1/models/user.dart';

class SharedPrefsUserRepository implements AbstractUserRepository {
  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (name != null && email != null && password != null) {
      return User(
          name: name, email: email, password: password, isLoggedIn: isLoggedIn);
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    await saveUser(user);
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Future<void> setUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }
}
