import 'package:tp_final_componentes/domain/models/ticket.dart';
import 'package:tp_final_componentes/domain/repositories/i_connection.dart';

class TicketRepository {
  final IConnection connection;

  TicketRepository(this.connection);

  Future<List<Ticket>> getTicketsByUser(String userId) async {
    final data = await connection.fetchCollection("tickets");
    return data
        .map((json) => Ticket.fromJson(json))
        .where((t) => t.userId == userId || t.guestId == userId)
        .toList();
  }

  Future<List<Ticket>> getTicketsAbiertos() async {
    final data = await connection.fetchCollection("tickets");
    return data.map((json) => Ticket.fromJson(json)).where((t) => t.abierto).toList();
  }

  Future<List<Ticket>> getTicketsBySlot(String slotId) async {
    final data = await connection.fetchCollection("tickets");
    return data.map((json) => Ticket.fromJson(json)).where((t) => t.slotId == slotId).toList();
  }
}