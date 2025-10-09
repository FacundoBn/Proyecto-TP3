class TicketView {
  final String id;
  final String patente;
  final String slotId;
  final DateTime ingreso;
  final DateTime? egreso;
  final num? precioFinal;
  final String userId;
  final String? guestId;

  const TicketView({
    required this.id,
    required this.patente,
    required this.slotId,
    required this.ingreso,
    required this.egreso,
    required this.precioFinal,
    required this.userId,
    required this.guestId,
  });

  bool get activo => egreso == null;

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
