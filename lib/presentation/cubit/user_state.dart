part of 'user_cubit.dart';

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoaded extends UserState {
  final List<User> users;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const UserLoaded({
    required this.users,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  @override
  List<Object?> get props => [users, isCreating, isUpdating, isDeleting];

  UserLoaded copyWith({
    List<User>? users,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class UserLoading extends UserState {
  const UserLoading();
}

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}
