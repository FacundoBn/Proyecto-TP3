class TicketView {
  final String id;
  final String patente;
  final String slotId;
  final DateTime ingreso;
  final DateTime? egreso;
  final num? precioFinal;
  final String userId;
  final String? guestId;

  bool get activo => egreso == null;

  TicketView({
    required this.id,
    required this.patente,
    required this.slotId,
    required this.ingreso,
    required this.egreso,
    required this.precioFinal,
    required this.userId,
    required this.guestId,
  });
}
