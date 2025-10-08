import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../models/parking_session.dart';
import '../../../services/storage_service.dart';
import '../../pricing/state/pricing_provider.dart';
class ParkingProvider extends ChangeNotifier {
  final StorageService _store;
  final PricingProvider _pricing;
  final _uuid = const Uuid();
  ParkingSession? _current;
  Timer? _ticker;
  List<ParkingSession> _history = [];
  ParkingProvider(this._store, this._pricing);
  ParkingSession? get current => _current;
  List<ParkingSession> get history => List.unmodifiable(_history);
  Future<void> init() async {
    _history = await _store.loadHistory();
    notifyListeners();
  }
  void _tick() => notifyListeners();
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }
  Future<void> start(String plate, String zone) async {
    final rate = _pricing.priceFor(zone);
    _current = ParkingSession(
      id: _uuid.v4(),
      plate: plate.toUpperCase(),
      zone: zone,
      startedAt: DateTime.now(),
      accumulatedSeconds: 0,
      status: SessionStatus.active,
      ratePerHour: rate,
    );
    _startTicker();
    notifyListeners();
  }
  void pause() {
    if (_current == null || _current!.status != SessionStatus.active) return;
    final now = DateTime.now();
    final elapsed = now.difference(_current!.startedAt).inSeconds;
    _current = ParkingSession(
      id: _current!.id,
      plate: _current!.plate,
      zone: _current!.zone,
      startedAt: now,
      accumulatedSeconds: _current!.accumulatedSeconds + elapsed,
      status: SessionStatus.paused,
      ratePerHour: _current!.ratePerHour,
      amount: _current!.amount,
      endedAt: _current!.endedAt,
    );
    _ticker?.cancel();
    notifyListeners();
  }
  void resume() {
    if (_current == null || _current!.status != SessionStatus.paused) return;
    _current = ParkingSession(
      id: _current!.id,
      plate: _current!.plate,
      zone: _current!.zone,
      startedAt: DateTime.now(),
      accumulatedSeconds: _current!.accumulatedSeconds,
      status: SessionStatus.active,
      ratePerHour: _current!.ratePerHour,
      amount: _current!.amount,
      endedAt: _current!.endedAt,
    );
    _startTicker();
    notifyListeners();
  }
  double estimateAmount() {
    if (_current == null) return 0.0;
    final seconds = _current!.elapsed.inSeconds;
    final hours = seconds / 3600.0;
    return double.parse((hours * _current!.ratePerHour).toStringAsFixed(2));
  }
  Future<ParkingSession?> finish() async {
    if (_current == null) return null;
    final finalAmount = estimateAmount();
    final finished = ParkingSession(
      id: _current!.id,
      plate: _current!.plate,
      zone: _current!.zone,
      startedAt: _current!.startedAt,
      endedAt: DateTime.now(),
      accumulatedSeconds: _current!.elapsed.inSeconds,
      status: SessionStatus.finished,
      ratePerHour: _current!.ratePerHour,
      amount: finalAmount,
    );
    _history = [finished, ..._history];
    await _store.saveHistory(_history);
    _ticker?.cancel();
    _current = null;
    notifyListeners();
    return finished;
  }
}
