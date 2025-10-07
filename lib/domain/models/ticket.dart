// =============================
// TICKET
// =============================
class Ticket {
  final String id; // ID único en Firebase
  final String vehicleId;
  final String userId; // dueño del vehículo
  final String? guestId; // invitado asociado, si aplica
  final String slotId;

  final DateTime ingreso;
  final DateTime? egreso;

  
  final double? precioFinal; 

  Ticket({
    required this.id,
    required this.vehicleId,
    required this.userId,
    this.guestId,
    required this.slotId,
    required this.ingreso,
    this.egreso,
    this.precioFinal,
  });

  Duration get duracion => (egreso ?? DateTime.now()).difference(ingreso);

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      userId: json['userId'] as String,
      guestId: json['guestId'] as String?,
      slotId: json['slotId'] as String,
      ingreso: DateTime.parse(json['ingreso'] as String),
      egreso: json['egreso'] != null ? DateTime.parse(json['egreso'] as String) : null,
      precioFinal: json['precioFinal'] != null ? (json['precioFinal'] as num).toDouble() : null,
    );
  }

  bool get abierto => egreso == null;
}