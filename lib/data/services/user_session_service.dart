import '../../domain/entities/user.dart';

class UserSessionService {
  static UserSessionService? _instance;
  static UserSessionService get instance {
    _instance ??= UserSessionService._();
    return _instance!;
  }

  User? _currentUser;

  UserSessionService._();

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  void clearCurrentUser() {
    _currentUser = null;
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }
}

