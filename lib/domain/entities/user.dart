import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final int userId;
  final String country;
  final String department;
  final String municipality;

  const Address({
    required this.id,
    required this.userId,
    required this.country,
    required this.department,
    required this.municipality,
  });

  @override
  List<Object?> get props => [id, userId, country, department, municipality];

  Address copyWith({
    int? id,
    int? userId,
    String? country,
    String? department,
    String? municipality,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      country: country ?? this.country,
      department: department ?? this.department,
      municipality: municipality ?? this.municipality,
    );
  }
}

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, birthDate, addresses];

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }
}
