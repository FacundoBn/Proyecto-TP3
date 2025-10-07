// =============================
// PATENTE (vehículo)
// =============================
class Vehicle {
  final String id; // ID único en Firebase
  final String numero; // ej. "AB123CD"
  final String usuarioId; // dueño (1 usuario ↔ muchas patentes)

  Vehicle({
    required this.id,
    required this.numero,
    required this.usuarioId,
  });
}