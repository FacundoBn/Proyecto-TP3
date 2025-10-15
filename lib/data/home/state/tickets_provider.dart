import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/repositories/i_connection.dart';
import '../../../models/ticket.dart';
import '../../../models/vehicle.dart';

class TicketsProvider extends ChangeNotifier {
  final IConnection _conn;
  TicketsProvider(this._conn);

  bool _loading = false;
  List<TicketView> _items = [];
  List<Vehicle> _vehicles = [];

  String? _currentActiveId;

  bool get loading => _loading;
  List<TicketView> get items => List.unmodifiable(_items);
  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  TicketView? get currentActive {
    final id = _currentActiveId;
    if (id == null) return null;
    final i = _items.indexWhere((t) => t.id == id && t.egreso == null);
    return i >= 0 ? _items[i] : null;
  }

  TicketView? getById(String id) {
    final i = _items.indexWhere((t) => t.id == id);
    return i >= 0 ? _items[i] : null;
  }

  Future<void> load() async {
    _loading = true; notifyListeners();

    final ticketsRaw = await _conn.fetchCollection('tickets');
    final vehiclesRaw = await _conn.fetchCollection('vehicles');

    _vehicles = vehiclesRaw.map((v) => Vehicle.fromMap(v)).toList();
    final vehicleById = {for (final v in _vehicles) v.id: v};

    _items = ticketsRaw.map((t) {
      final vehicle = vehicleById[(t['vehicleId'] ?? '').toString()];
      final patente = (vehicle?.numero ?? '—');
      return TicketView(
        id: (t['id'] ?? '').toString(),
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
    _loading = false; notifyListeners();
  }

  /// ⇢ NUEVO: seleccionar qué ticket activo queda “en foco”
  void setCurrentActive(String id) {
    _currentActiveId = id;
    notifyListeners();
  }

  /// Crear estadía activa en memoria
  TicketView startSession({
    required String plate,
    String slotId = 'S1',
    String userId = 'u1',
    String? guestId,
  }) {
    final now = DateTime.now().toUtc();
    final id = const Uuid().v4();

    final ticket = TicketView(
      id: id,
      patente: plate.toUpperCase(),
      slotId: slotId,
      ingreso: now,
      egreso: null,
      precioFinal: null,
      userId: userId,
      guestId: guestId,
    );

    _items = [ticket, ..._items];
    _currentActiveId = id;
    notifyListeners();
    return ticket;
  }

  /// Finalizar y calcular monto simple
  void finishSession(String ticketId, {num ratePerHour = 100}) {
    final idx = _items.indexWhere((t) => t.id == ticketId);
    if (idx < 0) return;

    final now = DateTime.now().toUtc();
    final t = _items[idx];
    if (t.egreso != null) return;

    final minutes = now.difference(t.ingreso).inMinutes.clamp(1, 1000000);
    final amount = (ratePerHour / 60.0) * minutes;

    _items[idx] = t.copyWith(egreso: now, precioFinal: amount);

    if (_currentActiveId == ticketId) _currentActiveId = null;
    notifyListeners();
  }

  // ── Gestión de vehículos (para Settings) ─────────────────────

  Future<void> addVehicle(Vehicle v) async {
    _vehicles = [v, ..._vehicles];
    notifyListeners();
    await _conn.saveCollection('vehicles', _vehicles.map((e) => e.toMap()).toList());
  }

  Future<void> renameVehicle({required String id, required String newPatente}) async {
    final idx = _vehicles.indexWhere((v) => v.id == id);
    if (idx < 0) return;
    _vehicles[idx] = _vehicles[idx].copyWith(numero: newPatente.toUpperCase());
    notifyListeners();
    await _conn.saveCollection('vehicles', _vehicles.map((e) => e.toMap()).toList());
  }

  Future<void> deleteVehicle(String id) async {
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
    await _conn.saveCollection('vehicles', _vehicles.map((e) => e.toMap()).toList());
  }
}

// copyWith para TicketView
extension on TicketView {
  TicketView copyWith({
    String? id,
    String? patente,
    String? slotId,
    DateTime? ingreso,
    DateTime? egreso,
    num? precioFinal,
    String? userId,
    String? guestId,
  }) {
    return TicketView(
      id: id ?? this.id,
      patente: patente ?? this.patente,
      slotId: slotId ?? this.slotId,
      ingreso: ingreso ?? this.ingreso,
      egreso: egreso ?? this.egreso,
      precioFinal: precioFinal ?? this.precioFinal,
      userId: userId ?? this.userId,
      guestId: guestId ?? this.guestId,
    );
  }
}
