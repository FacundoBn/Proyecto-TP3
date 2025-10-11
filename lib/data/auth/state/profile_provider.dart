import 'package:flutter/foundation.dart';
import '../../../domain/repositories/i_connection.dart';

class ProfileProvider extends ChangeNotifier {
  final IConnection _conn;
  ProfileProvider(this._conn);

  bool _loading = false;
  Map<String, dynamic> _profile = {
    'id': 'current',
    'name': 'Usuario Demo',
    'email': 'admin@demo.com',
    'password': '******',
  };

  bool get loading => _loading;
  String get name => (_profile['name'] ?? '').toString();
  String get email => (_profile['email'] ?? '').toString();
  String get password => (_profile['password'] ?? '').toString();

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final list = await _conn.fetchCollection('profile');
      _profile = Map<String, dynamic>.from(list.first);
      await _conn.saveCollection('profile', [_profile]);

    _loading = false;
    notifyListeners();
  }

  Future<void> updateEmailPassword({String? email, String? password}) async {
    final list = await _conn.fetchCollection('profile');
    Map<String, dynamic> current;
    if (list.isEmpty) {
      current = {'id': 'current', ..._profile};
      list.add(current);
    } else {
      current = Map<String, dynamic>.from(list.first);
    }

    if (email != null) current['email'] = email;
    if (password != null) current['password'] = password;

    await _conn.saveCollection('profile', [current]);

    _profile = current;
    notifyListeners();
  }
}
