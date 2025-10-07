import 'dart:convert';
import 'package:tp_final_componentes/domain/repositories/i_connection.dart';


class HardcodeConnection implements IConnection {
  final Map<String, List<Map<String, dynamic>>> mockDb = {
  "users": [
    {"id": "u1", "nombre": "Emiliano", "apellido": "Fernandez", "userName": "emifern", "password": "1234"},
    {"id": "u2", "nombre": "Ana", "apellido": "Gomez", "userName": "anag", "password": "1234"}
  ],
  "tickets": [
    {
      "id": "t1",
      "vehicleId": "v1",
      "userId": "u1",
      "guestId": null,
      "slotId": "s1",
      "ingreso": "2025-10-01T10:00:00Z",
      "egreso": null,
      "precioFinal": null
    },
    {
      "id": "t2",
      "vehicleId": "v2",
      "userId": "u2",
      "guestId": "u1",
      "slotId": "s2",
      "ingreso": "2025-10-01T09:30:00Z",
      "egreso": "2025-10-01T11:00:00Z",
      "precioFinal": 200
    }
  ],
  "vehicles": [
    {"id": "v1", "numero": "AB123CD", "usuarioId": "u1"},
    {"id": "v2", "numero": "XY987ZT", "usuarioId": "u2"}
  ],
  "slots": [
    {"id": "s1", "patenteId": "v1"},
    {"id": "s2", "patenteId": "v2"},
    {"id": "s3", "patenteId": null}
  ]
};

  

  @override
  Future<List<Map<String, dynamic>>> fetchCollection(String collectionName) async {
    // cast necesario porque db[collectionName] devuelve List<dynamic> implícitamente
    return (mockDb[collectionName] ?? []).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> saveCollection(String collectionName, List<Map<String, dynamic>> data) async {
    mockDb[collectionName] = data;
  }
}