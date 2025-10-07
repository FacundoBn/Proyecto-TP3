// =============================
// COCHERA
// =============================
class Slot {
  final String id; // ID único en Firebase
  final String? patenteId; 
  // null = libre, caso contrario ocupada por ese vehículo

  Slot({
    required this.id,
    this.patenteId,
  });
}