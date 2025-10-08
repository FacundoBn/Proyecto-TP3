import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parking_session.dart';
class StorageService {
  static const _kHistory = 'history';
  static const _kPricing = 'pricing';
  static const _kSupervisor = 'supervisor';
  Future<void> saveHistory(List<ParkingSession> items) async {
    final prefs = await SharedPreferences.getInstance();
    final list = items.map((e) => e.toMap()).toList();
    await prefs.setString(_kHistory, jsonEncode(list));
  }
  Future<List<ParkingSession>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kHistory);
    if (raw == null || raw.isEmpty) return [];
    final data = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return data.map(ParkingSession.fromMap).toList();
  }
  Future<void> savePricing(Map<String, double> pricing) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPricing, jsonEncode(pricing));
  }
  Future<Map<String, double>> loadPricing() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPricing);
    if (raw == null) return {};
    final m = (jsonDecode(raw) as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
    return m;
  }
  Future<void> setSupervisor(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSupervisor, value);
  }
  Future<bool> isSupervisor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kSupervisor) ?? false;
  }
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
