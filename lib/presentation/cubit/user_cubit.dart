import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/delete_all_users_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase _getUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final DeleteAllUsersUseCase _deleteAllUsersUseCase;

  UserCubit({
    required GetUsersUseCase getUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required DeleteAllUsersUseCase deleteAllUsersUseCase,
  }) : _getUsersUseCase = getUsersUseCase,
       _createUserUseCase = createUserUseCase,
       _updateUserUseCase = updateUserUseCase,
       _deleteUserUseCase = deleteUserUseCase,
       _deleteAllUsersUseCase = deleteAllUsersUseCase,
       super(const UserInitial());

  Future<void> createUser(User user) async {
    emit(const UserLoading());

    try {
      final createdUser = await _createUserUseCase(user);

      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        final updatedUsers = [...currentState.users, createdUser];
        emit(UserLoaded(users: updatedUsers));
      } else {
        final users = await _getUsersUseCase();
        emit(UserLoaded(users: users));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> deleteUser(int id) async {
    emit(const UserLoading());

    try {
      await _deleteUserUseCase(id);

      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        final updatedUsers = currentState.users
            .where((user) => user.id != id)
            .toList();
        emit(UserLoaded(users: updatedUsers));
      } else {
        final users = await _getUsersUseCase();
        emit(UserLoaded(users: users));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> getUsers() async {
    emit(const UserLoading());

    try {
      final users = await _getUsersUseCase();
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser(User user) async {
    emit(const UserLoading());

    try {
      final updatedUser = await _updateUserUseCase(user);

      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        final updatedUsers = currentState.users
            .map((u) => u.id == user.id ? updatedUser : u)
            .toList();
        emit(UserLoaded(users: updatedUsers));
      } else {
        final users = await _getUsersUseCase();
        emit(UserLoaded(users: users));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> deleteAllUsers() async {
    emit(const UserLoading());

    try {
      await _deleteAllUsersUseCase();
      emit(const UserLoaded(users: []));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
