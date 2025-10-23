import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../services/database_service.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> createUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final db = await DatabaseService.database;

      final userId = await db.insert('users', {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'birthDate': user.birthDate.toIso8601String(),
      });

      final addresses = <Address>[];
      for (final address in user.addresses) {
        final addressId = await db.insert('addresses', {
          'userId': userId,
          'country': address.country,
          'department': address.department,
          'municipality': address.municipality,
        });
        addresses.add(address.copyWith(id: addressId, userId: userId));
      }

      return user.copyWith(id: userId, addresses: addresses);
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final db = await DatabaseService.database;
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  @override
  Future<User> getUserById(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final db = await DatabaseService.database;

      final userMaps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (userMaps.isEmpty) {
        throw Exception('Usuario no encontrado');
      }

      final userMap = userMaps.first;
      final addressMaps = await db.query(
        'addresses',
        where: 'userId = ?',
        whereArgs: [id],
      );

      final addresses = addressMaps
          .map(
            (map) => Address(
              id: map['id'] as int,
              userId: map['userId'] as int,
              country: map['country'] as String,
              department: map['department'] as String,
              municipality: map['municipality'] as String,
            ),
          )
          .toList();

      return User(
        id: userMap['id'] as int,
        firstName: userMap['firstName'] as String,
        lastName: userMap['lastName'] as String,
        birthDate: DateTime.parse(userMap['birthDate'] as String),
        addresses: addresses,
      );
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final db = await DatabaseService.database;
      final userMaps = await db.query('users', orderBy: 'firstName ASC');

      final users = <User>[];
      for (final userMap in userMaps) {
        final userId = userMap['id'] as int;
        final addressMaps = await db.query(
          'addresses',
          where: 'userId = ?',
          whereArgs: [userId],
        );

        final addresses = addressMaps
            .map(
              (map) => Address(
                id: map['id'] as int,
                userId: map['userId'] as int,
                country: map['country'] as String,
                department: map['department'] as String,
                municipality: map['municipality'] as String,
              ),
            )
            .toList();

        users.add(
          User(
            id: userId,
            firstName: userMap['firstName'] as String,
            lastName: userMap['lastName'] as String,
            birthDate: DateTime.parse(userMap['birthDate'] as String),
            addresses: addresses,
          ),
        );
      }

      return users;
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final db = await DatabaseService.database;

      await db.update(
        'users',
        {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'birthDate': user.birthDate.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );

      await db.delete('addresses', where: 'userId = ?', whereArgs: [user.id]);

      final addresses = <Address>[];
      for (final address in user.addresses) {
        final addressId = await db.insert('addresses', {
          'userId': user.id,
          'country': address.country,
          'department': address.department,
          'municipality': address.municipality,
        });
        addresses.add(address.copyWith(id: addressId, userId: user.id));
      }

      return user.copyWith(addresses: addresses);
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }
}
