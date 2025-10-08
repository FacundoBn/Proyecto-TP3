import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class AuthRepository {
  static const _kUsers = 'auth_users';
  static const _kSession = 'auth_session';
  Future<Map<String, String>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUsers);
    if (raw == null) return {};
    final m = (jsonDecode(raw) as Map).map((k, v) => MapEntry(k.toString(), v.toString()));
    return m;
  }
  Future<void> _saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsers, jsonEncode(users));
  }
  Future<void> register(String email, String password) async {
    email = email.trim().toLowerCase();
    final users = await _loadUsers();
    if (users.containsKey(email)) { throw Exception('El usuario ya existe'); }
    users[email] = password; await _saveUsers(users);
  }
  Future<bool> login(String email, String password) async {
    email = email.trim().toLowerCase();
    final users = await _loadUsers();
    final ok = users[email] == password;
    if (ok) { final prefs = await SharedPreferences.getInstance(); await prefs.setString(_kSession, email); }
    return ok;
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSession);
  }
  Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSession);
  }
  Future<void> ensureDemoUser() async {
    final users = await _loadUsers();
    if (users.isEmpty) { users['admin@demo.com'] = '123456'; await _saveUsers(users); }
  }
}
