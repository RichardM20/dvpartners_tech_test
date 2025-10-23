import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/domain/repositories/user_repository.dart';
import 'package:dvpartners_tech_test/domain/usecases/get_users_usecase.dart';

import 'get_users_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUsersUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUsersUseCase(mockRepository);
  });

  group('GetUsersUseCase', () {
    final testUsers = [
      User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [
          Address(
            id: 1,
            userId: 1,
            country: 'Colombia',
            department: 'Bogotá D.C.',
            municipality: 'Bogotá',
          ),
        ],
      ),
      User(
        id: 2,
        firstName: 'María',
        lastName: 'García',
        birthDate: DateTime(1985, 5, 15),
        addresses: [
          Address(
            id: 2,
            userId: 2,
            country: 'México',
            department: 'Ciudad de México',
            municipality: 'Álvaro Obregón',
          ),
        ],
      ),
    ];

    test('should return list of users when repository call is successful', () async {
      when(mockRepository.getUsers()).thenAnswer((_) async => testUsers);

      final result = await useCase();

      expect(result, equals(testUsers));
      verify(mockRepository.getUsers()).called(1);
    });

    test('should throw exception when repository call fails', () async {
      when(mockRepository.getUsers()).thenThrow(Exception('Database error'));

      expect(() => useCase(), throwsException);
      verify(mockRepository.getUsers()).called(1);
    });

    test('should return empty list when no users exist', () async {
      when(mockRepository.getUsers()).thenAnswer((_) async => <User>[]);

      final result = await useCase();

      expect(result, isEmpty);
      verify(mockRepository.getUsers()).called(1);
    });
  });
}