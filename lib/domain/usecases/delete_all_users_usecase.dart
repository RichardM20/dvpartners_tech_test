import '../repositories/user_repository.dart';

class DeleteAllUsersUseCase {
  final UserRepository _userRepository;

  DeleteAllUsersUseCase(this._userRepository);

  Future<void> call() async {
    await _userRepository.deleteAllUsers();
  }
}
