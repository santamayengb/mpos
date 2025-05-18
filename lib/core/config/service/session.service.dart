import 'package:mpos/core/config/model/session.model.dart';
import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/objectbox.g.dart';

class SessionService {
  /// Create a session linked to a specific user
  static int createSession({required int userId, required String ipAddress}) {
    final user = userBox.get(userId);
    if (user == null) {
      throw Exception("User not found");
    }

    final session = Session(ipAddress: ipAddress, createdAt: DateTime.now());

    session.user.target = user;
    return sessionBox.put(session);
  }

  /// Get all sessions for all users
  static List<Session> getAllSessions() {
    return sessionBox.getAll();
  }

  /// Get sessions for a specific user
  static List<Session> getSessionsByUser(int userId) {
    final user = userBox.get(userId);
    return user?.sessions ?? [];
  }

  /// Delete all sessions for a user (optional utility)
  static void deleteSessionsByUser(int userId) {
    final sessions = getSessionsByUser(userId);
    for (final s in sessions) {
      sessionBox.remove(s.id);
    }
  }

  /// Delete a specific session
  static void deleteSession(int sessionId) {
    sessionBox.remove(sessionId);
  }

  /// Get the latest session of a user
  static Session? getLatestSession(int userId) {
    final query =
        sessionBox
            .query(Session_.user.equals(userId))
            .order(Session_.createdAt, flags: Order.descending)
            .build();

    final results = query.find();
    query.close();
    return results.isNotEmpty ? results.first : null;
  }
}
