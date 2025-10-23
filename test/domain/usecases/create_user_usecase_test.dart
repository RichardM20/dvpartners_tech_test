import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/domain/repositories/user_repository.dart';
import 'package:dvpartners_tech_test/domain/usecases/create_user_usecase.dart';

import 'create_user_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late CreateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = CreateUserUseCase(mockRepository);
  });

  group('CreateUserUseCase', () {
    final testUser = User(
      id: 0,
      firstName: 'Juan',
      lastName: 'Pérez',
      birthDate: DateTime(1990, 1, 1),
      addresses: [
        Address(
          id: 0,
          userId: 0,
          country: 'Colombia',
          department: 'Bogotá D.C.',
          municipality: 'Bogotá',
        ),
      ],
    );

    final createdUser = testUser.copyWith(
      id: 1,
      addresses: [testUser.addresses.first.copyWith(id: 1, userId: 1)],
    );

    test(
      'should create user and return created user with assigned ID',
      () async {
        when(
          mockRepository.createUser(testUser),
        ).thenAnswer((_) async => createdUser);

        final result = await useCase(testUser);

        expect(result, equals(createdUser));
        expect(result.id, equals(1));
        verify(mockRepository.createUser(testUser)).called(1);
      },
    );

    test('should throw exception when repository call fails', () async {
      when(
        mockRepository.createUser(testUser),
      ).thenThrow(Exception('Database error'));

      expect(() => useCase(testUser), throwsException);
      verify(mockRepository.createUser(testUser)).called(1);
    });

    test('should create user with multiple addresses', () async {
      final userWithMultipleAddresses = testUser.copyWith(
        addresses: [
          testUser.addresses.first,
          Address(
            id: 0,
            userId: 0,
            country: 'México',
            department: 'Jalisco',
            municipality: 'Guadalajara',
          ),
        ],
      );

      final createdUserWithMultipleAddresses = userWithMultipleAddresses
          .copyWith(
            id: 1,
            addresses: [
              userWithMultipleAddresses.addresses[0].copyWith(id: 1, userId: 1),
              userWithMultipleAddresses.addresses[1].copyWith(id: 2, userId: 1),
            ],
          );

      when(
        mockRepository.createUser(userWithMultipleAddresses),
      ).thenAnswer((_) async => createdUserWithMultipleAddresses);

      final result = await useCase(userWithMultipleAddresses);

      expect(result, equals(createdUserWithMultipleAddresses));
      expect(result.addresses.length, equals(2));
      verify(mockRepository.createUser(userWithMultipleAddresses)).called(1);
    });
  });
}
