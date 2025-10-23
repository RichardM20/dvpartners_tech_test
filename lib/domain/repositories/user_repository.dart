import '../entities/user.dart';

abstract class UserRepository {
  Future<User> createUser(User user);
  Future<void> deleteUser(int id);
  Future<User> getUserById(int id);
  Future<List<User>> getUsers();
  Future<User> updateUser(User user);
}
