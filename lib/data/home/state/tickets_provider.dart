import 'package:flutter/foundation.dart';
import '../../../domain/repositories/i_connection.dart';
import '../../../models/ticket.dart';

class TicketsProvider extends ChangeNotifier {
  final IConnection _conn;
  TicketsProvider(this._conn);

  bool _loading = false;
  List<TicketView> _items = [];
  String? _activeId;

  final Map<String, Map<String, dynamic>> _vehiclesById = {};

  bool get loading => _loading;
  List<TicketView> get items => List.unmodifiable(_items);

  List<String> get patentes {
    final all = _vehiclesById.values
        .map((v) => (v['numero'] ?? '—').toString())
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  List<VehicleView> get vehicles {
    final list = _vehiclesById.entries
        .map((e) => VehicleView(id: e.key, patente: (e.value['numero'] ?? '—').toString()))
        .toList();
    list.sort((a, b) => a.patente.compareTo(b.patente));
    return list;
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    // 1) Vehículos
    final vehicles = await _conn.fetchCollection('vehicles');
    _vehiclesById
      ..clear()
      ..addEntries(vehicles.map((v) => MapEntry(v['id'].toString(), Map<String, dynamic>.from(v))));

    // 2) Tickets
    final tickets = await _conn.fetchCollection('tickets');
    _items = tickets.map((t) {
      final vehId = t['vehicleId']?.toString();
      final vehicle = vehId != null ? _vehiclesById[vehId] : null;
      final patente = (vehicle?['numero'] ?? '—').toString();
      return TicketView(
        id: t['id'].toString(),
        patente: patente,
        slotId: (t['slotId'] ?? '—').toString(),
        ingreso: DateTime.parse(t['ingreso'].toString()),
        egreso: t['egreso'] != null ? DateTime.parse(t['egreso'].toString()) : null,
        precioFinal: t['precioFinal'] as num?,
        userId: (t['userId'] ?? '').toString(),
        guestId: t['guestId']?.toString(),
      );
    }).toList();

    _items.sort((a, b) => b.ingreso.compareTo(a.ingreso));

    if (_activeId != null && !_items.any((t) => t.id == _activeId)) {
      _activeId = null;
    }

    _loading = false;
    notifyListeners();
  }

  TicketView? get active {
    if (_activeId != null) {
      try {
        return _items.firstWhere((t) => t.id == _activeId);
      } catch (_) {}
    }
    final activos = _items.where((t) => t.activo).toList()
      ..sort((a, b) => b.ingreso.compareTo(a.ingreso));
    return activos.isEmpty ? null : activos.first;
  }

  void setActive(TicketView t) {
    _activeId = t.id;
    notifyListeners();
  }

  void clearActive() {
    _activeId = null;
    notifyListeners();
  }

  Future<TicketView?> closeActiveSession() async {
    final current = active;
    if (current == null) return null;

    final now = DateTime.now();
    final updated = current.copyWith(egreso: now);

    final idx = _items.indexWhere((t) => t.id == current.id);
    if (idx != -1) {
      _items[idx] = updated;
      if (_activeId == current.id) _activeId = null;
      notifyListeners();
    }
    return updated;
  }


  Future<void> addVehicle(String patente) async {
    final list = await _conn.fetchCollection('vehicles');

    final newId = _generateId(list);

    list.add({'id': newId, 'numero': patente});

    await _conn.saveCollection('vehicles', list);

    await load();
  }

  Future<void> renameVehicle({required String id, required String newPatente}) async {
    final list = await _conn.fetchCollection('vehicles');

    final idx = list.indexWhere((v) => v['id'].toString() == id);
    if (idx == -1) return;

    final current = Map<String, dynamic>.from(list[idx]);
    current['numero'] = newPatente;
    list[idx] = current;

    await _conn.saveCollection('vehicles', list);
    await load();
  }

  Future<void> deleteVehicle(String id) async {
    final list = await _conn.fetchCollection('vehicles');
    list.removeWhere((v) => v['id'].toString() == id);

    await _conn.saveCollection('vehicles', list);
    await load();
  }

  String _generateId(List<Map<String, dynamic>> current) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    var id = ts.toString();
    var suffix = 0;
    final existing = current.map((e) => e['id'].toString()).toSet();
    while (existing.contains(id)) {
      suffix += 1;
      id = '$ts-$suffix';
    }
    return id;
  }
}

class VehicleView {
  final String id;
  final String patente;
  VehicleView({required this.id, required this.patente});
}
