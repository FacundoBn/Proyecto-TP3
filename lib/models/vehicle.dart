class Vehicle {
  final String id;
  final String numero;   // patente
  final String usuarioId;

  Vehicle({
    required this.id,
    required this.numero,
    required this.usuarioId,
  });

  Vehicle copyWith({String? id, String? numero, String? usuarioId}) {
    return Vehicle(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: (map['id'] ?? '').toString(),
      numero: (map['numero'] ?? '').toString(),
      usuarioId: (map['usuarioId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'numero': numero,
    'usuarioId': usuarioId,
  };
}
