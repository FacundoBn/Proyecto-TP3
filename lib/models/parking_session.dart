import 'dart:convert';
enum SessionStatus { active, paused, finished }
class ParkingSession {
  final String id;
  String plate;
  String zone;
  DateTime startedAt;
  DateTime? endedAt;
  int accumulatedSeconds;
  SessionStatus status;
  double ratePerHour;
  double amount;
  ParkingSession({
    required this.id,
    required this.plate,
    required this.zone,
    required this.startedAt,
    this.endedAt,
    this.accumulatedSeconds = 0,
    this.status = SessionStatus.active,
    required this.ratePerHour,
    this.amount = 0.0,
  });
  Duration get elapsed {
    if (status == SessionStatus.finished) return Duration(seconds: accumulatedSeconds);
    final now = DateTime.now();
    final base = accumulatedSeconds + now.difference(startedAt).inSeconds;
    return Duration(seconds: base);
  }
  Map<String, dynamic> toMap() => {
    'id': id,
    'plate': plate,
    'zone': zone,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'accumulatedSeconds': accumulatedSeconds,
    'status': status.name,
    'ratePerHour': ratePerHour,
    'amount': amount,
  };
  static ParkingSession fromMap(Map<String, dynamic> m) => ParkingSession(
    id: m['id'],
    plate: m['plate'],
    zone: m['zone'],
    startedAt: DateTime.parse(m['startedAt']),
    endedAt: m['endedAt'] != null ? DateTime.parse(m['endedAt']) : null,
    accumulatedSeconds: (m['accumulatedSeconds'] ?? 0) as int,
    status: SessionStatus.values.firstWhere((e) => e.name == m['status']),
    ratePerHour: (m['ratePerHour'] as num).toDouble(),
    amount: (m['amount'] as num).toDouble(),
  );
  String toJson() => jsonEncode(toMap());
  static ParkingSession fromJson(String s) => fromMap(jsonDecode(s) as Map<String, dynamic>);
}
