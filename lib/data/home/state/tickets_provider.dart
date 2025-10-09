import 'package:flutter/foundation.dart';
import '../../../domain/repositories/i_connection.dart';
import '../../../models/ticket.dart';

class TicketsProvider extends ChangeNotifier {
  final IConnection _conn;
  TicketsProvider(this._conn);

  bool _loading = false;
  List<TicketView> _items = [];

  bool get loading => _loading;
  List<TicketView> get items => List.unmodifiable(_items);

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final tickets = await _conn.fetchCollection('tickets');
    final vehicles = await _conn.fetchCollection('vehicles');
    final vehicleById = {for (final v in vehicles) v['id']: v};

    _items = tickets.map((t) {
      final vehicle = vehicleById[t['vehicleId']];
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
    _loading = false;
    notifyListeners();
  }

  TicketView? get active {
    final activos = _items.where((t) => t.activo).toList()
      ..sort((a, b) => b.ingreso.compareTo(a.ingreso));
    return activos.isEmpty ? null : activos.first;
  }

  Future<TicketView?> closeActiveSession() async {
    final current = active;
    if (current == null) return null;

    final now = DateTime.now();

    final updated = current.copyWith(
      egreso: now,
    );

    final idx = _items.indexWhere((t) => t.id == current.id);
    if (idx != -1) {
      _items[idx] = updated;
      notifyListeners();
    }
    return updated;
  }
}
