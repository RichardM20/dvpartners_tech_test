import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/domain/usecases/create_user_usecase.dart';
import 'package:dvpartners_tech_test/domain/usecases/delete_all_users_usecase.dart';
import 'package:dvpartners_tech_test/domain/usecases/delete_user_usecase.dart';
import 'package:dvpartners_tech_test/domain/usecases/get_users_usecase.dart';
import 'package:dvpartners_tech_test/domain/usecases/update_user_usecase.dart';
import 'package:dvpartners_tech_test/presentation/cubit/user_cubit.dart';

import 'user_cubit_test.mocks.dart';

@GenerateMocks([
  GetUsersUseCase,
  CreateUserUseCase,
  UpdateUserUseCase,
  DeleteUserUseCase,
  DeleteAllUsersUseCase,
])
void main() {
  late UserCubit userCubit;
  late MockGetUsersUseCase mockGetUsersUseCase;
  late MockCreateUserUseCase mockCreateUserUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;
  late MockDeleteUserUseCase mockDeleteUserUseCase;
  late MockDeleteAllUsersUseCase mockDeleteAllUsersUseCase;

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    mockCreateUserUseCase = MockCreateUserUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    mockDeleteUserUseCase = MockDeleteUserUseCase();
    mockDeleteAllUsersUseCase = MockDeleteAllUsersUseCase();

    userCubit = UserCubit(
      getUsersUseCase: mockGetUsersUseCase,
      createUserUseCase: mockCreateUserUseCase,
      updateUserUseCase: mockUpdateUserUseCase,
      deleteUserUseCase: mockDeleteUserUseCase,
      deleteAllUsersUseCase: mockDeleteAllUsersUseCase,
    );
  });

  tearDown(() {
    userCubit.close();
  });

  group('UserCubit', () {
    final testUser = User(
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
    );

    test('initial state should be UserInitial', () {
      expect(userCubit.state, equals(const UserInitial()));
    });

    group('getUsers', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when getUsers succeeds',
        build: () {
          when(mockGetUsersUseCase()).thenAnswer((_) async => [testUser]);
          return userCubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: [testUser]),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when getUsers fails',
        build: () {
          when(mockGetUsersUseCase()).thenThrow(Exception('Database error'));
          return userCubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          const UserLoading(),
          const UserError('Exception: Database error'),
        ],
      );
    });

    group('createUser', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when createUser succeeds',
        build: () {
          when(
            mockCreateUserUseCase(testUser),
          ).thenAnswer((_) async => testUser);
          when(mockGetUsersUseCase()).thenAnswer((_) async => [testUser]);
          return userCubit;
        },
        act: (cubit) => cubit.createUser(testUser),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: [testUser]),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when createUser fails',
        build: () {
          when(
            mockCreateUserUseCase(testUser),
          ).thenThrow(Exception('Create error'));
          return userCubit;
        },
        act: (cubit) => cubit.createUser(testUser),
        expect: () => [
          const UserLoading(),
          const UserError('Exception: Create error'),
        ],
      );
    });

    group('updateUser', () {
      final updatedUser = testUser.copyWith(firstName: 'Juan Carlos');

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when updateUser succeeds',
        build: () {
          when(
            mockUpdateUserUseCase(updatedUser),
          ).thenAnswer((_) async => updatedUser);
          when(mockGetUsersUseCase()).thenAnswer((_) async => [updatedUser]);
          return userCubit;
        },
        act: (cubit) => cubit.updateUser(updatedUser),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: [updatedUser]),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when updateUser fails',
        build: () {
          when(
            mockUpdateUserUseCase(updatedUser),
          ).thenThrow(Exception('Update error'));
          return userCubit;
        },
        act: (cubit) => cubit.updateUser(updatedUser),
        expect: () => [
          const UserLoading(),
          const UserError('Exception: Update error'),
        ],
      );
    });

    group('deleteUser', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when deleteUser succeeds',
        build: () {
          when(mockDeleteUserUseCase(1)).thenAnswer((_) async {});
          when(mockGetUsersUseCase()).thenAnswer((_) async => []);
          return userCubit;
        },
        act: (cubit) => cubit.deleteUser(1),
        expect: () => [const UserLoading(), const UserLoaded(users: [])],
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when deleteUser fails',
        build: () {
          when(mockDeleteUserUseCase(1)).thenThrow(Exception('Delete error'));
          return userCubit;
        },
        act: (cubit) => cubit.deleteUser(1),
        expect: () => [
          const UserLoading(),
          const UserError('Exception: Delete error'),
        ],
      );
    });

    group('deleteAllUsers', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when deleteAllUsers succeeds',
        build: () {
          when(mockDeleteAllUsersUseCase()).thenAnswer((_) async {});
          return userCubit;
        },
        act: (cubit) => cubit.deleteAllUsers(),
        expect: () => [const UserLoading(), const UserLoaded(users: [])],
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when deleteAllUsers fails',
        build: () {
          when(
            mockDeleteAllUsersUseCase(),
          ).thenThrow(Exception('Delete all error'));
          return userCubit;
        },
        act: (cubit) => cubit.deleteAllUsers(),
        expect: () => [
          const UserLoading(),
          const UserError('Exception: Delete all error'),
        ],
      );
    });
  });
}
