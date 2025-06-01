import 'package:lab_1/models/user.dart';

abstract class AbstractUserRepository {
  Future<void> saveUser(User user);

  Future<User?> getUser();

  Future<void> updateUser(User user);

  Future<void> clearUser();

  Future<void> logout();

  Future<bool> isUserLoggedIn();

  Future<void> setUserLoggedIn(bool value);
}
