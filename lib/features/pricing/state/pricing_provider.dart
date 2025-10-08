import 'package:flutter/foundation.dart';
import '../../../services/storage_service.dart';
class PricingProvider extends ChangeNotifier {
  final StorageService _store;
  Map<String, double> _pricing = {'A': 1000.0, 'B': 1200.0};
  bool _supervisor = false;
  PricingProvider(this._store);
  Map<String, double> get pricing => _pricing;
  bool get isSupervisor => _supervisor;
  double priceFor(String zone) => _pricing[zone] ?? 1000.0;
  Future<void> init() async {
    final loaded = await _store.loadPricing();
    if (loaded.isNotEmpty) _pricing = loaded;
    _supervisor = await _store.isSupervisor();
    notifyListeners();
  }
  Future<void> setPrice(String zone, double value) async {
    _pricing = {..._pricing, zone: value};
    await _store.savePricing(_pricing);
    notifyListeners();
  }
  Future<void> setSupervisor(bool value) async {
    _supervisor = value;
    await _store.setSupervisor(value);
    notifyListeners();
  }
}
