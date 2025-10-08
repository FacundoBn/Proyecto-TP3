import 'package:flutter/foundation.dart';
import '../data/auth_repository.dart';
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  AuthProvider(this._repo);
  bool _loading = false; String? _currentEmail;
  bool get loading => _loading; bool get logged => _currentEmail != null; String? get email => _currentEmail;
  Future<void> init() async { _loading = true; notifyListeners(); await _repo.ensureDemoUser(); _currentEmail = await _repo.currentUser(); _loading = false; notifyListeners(); }
  Future<bool> login(String email, String pass) async { _loading = true; notifyListeners(); final ok = await _repo.login(email, pass); _currentEmail = ok ? email.trim().toLowerCase() : null; _loading = false; notifyListeners(); return ok; }
  Future<bool> registerAndLogin(String email, String pass) async {
    _loading = true; notifyListeners();
    try { await _repo.register(email, pass); final ok = await _repo.login(email, pass); _currentEmail = ok ? email.trim().toLowerCase() : null; _loading = false; notifyListeners(); return ok; }
    catch (_) { _loading = false; notifyListeners(); return false; }
  }
  Future<void> logout() async { await _repo.logout(); _currentEmail = null; notifyListeners(); }
}
