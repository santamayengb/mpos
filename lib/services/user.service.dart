import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/core/config/model/session.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';

class UserService {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static void setCurrentUser(User user) {
    _currentUser = user;
  }

  /// Returns all users from the database
  static List<User> getAllUsers() {
    return userBox.getAll();
  }

  /// Finds a user by ID
  static User? getUserById(int id) {
    return userBox.get(id);
  }

  /// Adds a new user and returns the stored user
  static User addUser(User user) {
    user.id = userBox.put(user);
    return user;
  }

  /// Adds a new session for a user
  static Session addSession(User user, String ipAddress) {
    final session = Session(ipAddress: ipAddress, createdAt: DateTime.now());
    session.user.target = user;
    sessionBox.put(session);

    // Ensure backlink is updated
    user.sessions.add(session);
    userBox.put(user);

    return session;
  }

  /// Get sessions for a user
  static List<Session> getUserSessions(User user) {
    return user.sessions;
  }

  /// Get last session
  static Session? getLastSession(User user) {
    final sessions = user.sessions;
    if (sessions.isEmpty) return null;

    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions.first;
  }

  /// Deletes a user
  static void deleteUser(int id) {
    userBox.remove(id);
  }

  /// Deletes all users
  static void clearAllUsers() {
    userBox.removeAll();
  }
}
