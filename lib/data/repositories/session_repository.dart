import 'package:hive_flutter/hive_flutter.dart';
import '../models/session_state_model.dart';

class SessionRepository {
  static const _boxName = 'session_state';
  static const _key = 'active_session';

  Box<SessionStateModel> get _box => Hive.box<SessionStateModel>(_boxName);

  static Future<void> openBox() async {
    await Hive.openBox<SessionStateModel>(_boxName);
  }

  Future<void> saveSession(SessionStateModel session) async {
    await _box.put(_key, session);
  }

  SessionStateModel? getLastSession() => _box.get(_key);

  Future<void> clearSession() async {
    await _box.delete(_key);
  }
}
