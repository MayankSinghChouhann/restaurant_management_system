import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invoice.dart';

class StorageService {
  static const String _invoiceKey = 'gl_invoices';
  static const String _billCounterKey = 'gl_bill_counter';
  static const String _kotCounterKey = 'gl_kot_counter';
  static const int _retentionDays = 7;

  /// Load all invoices from storage, auto-purge those older than 7 days
  static Future<List<Invoice>> loadInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_invoiceKey) ?? [];
    final cutoff = DateTime.now().subtract(const Duration(days: _retentionDays));

    final invoices = <Invoice>[];
    final toKeep = <String>[];

    for (final jsonStr in raw) {
      try {
        final invoice = Invoice.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
        if (invoice.date.isAfter(cutoff)) {
          invoices.add(invoice);
          toKeep.add(jsonStr);
        }
        // Silently discard invoices older than 7 days
      } catch (_) {
        // Skip malformed entries
      }
    }

    // Persist cleaned list
    if (toKeep.length != raw.length) {
      await prefs.setStringList(_invoiceKey, toKeep);
    }

    // Sort newest first
    invoices.sort((a, b) => b.date.compareTo(a.date));
    return invoices;
  }

  /// Save a new invoice to persistent storage
  static Future<void> saveInvoice(Invoice invoice) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_invoiceKey) ?? [];
    raw.add(json.encode(invoice.toJson()));
    await prefs.setStringList(_invoiceKey, raw);
  }

  /// Delete a specific invoice by id
  static Future<void> deleteInvoice(String invoiceId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_invoiceKey) ?? [];
    final updated = raw.where((jsonStr) {
      try {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        return map['id'] != invoiceId;
      } catch (_) {
        return false;
      }
    }).toList();
    await prefs.setStringList(_invoiceKey, updated);
  }

  /// Get and increment bill counter for sequential bill numbers
  static Future<int> nextBillCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_billCounterKey) ?? 0;
    final next = current + 1;
    await prefs.setInt(_billCounterKey, next);
    return next;
  }

  /// Get and increment KOT counter
  static Future<int> nextKOTCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_kotCounterKey) ?? 0;
    final next = current + 1;
    await prefs.setInt(_kotCounterKey, next);
    return next;
  }
}
