import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice.dart';
import '../models/cart_item.dart';
import '../services/billing_calculator.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class OrderNotifier extends StateNotifier<List<Invoice>> {
  OrderNotifier() : super([]) {
    _loadFromStorage();
  }

  /// Load invoices from persistent storage on startup (auto-purges >7 days)
  Future<void> _loadFromStorage() async {
    final invoices = await StorageService.loadInvoices();
    state = invoices;
  }

  Future<Invoice> generateInvoice(
    List<CartItem> cartItems, {
    String? tableOrRoom,
  }) async {
    if (cartItems.isEmpty) {
      throw Exception('Please add at least one item to the order.');
    }

    final now = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(now);
    final seq = await StorageService.nextBillCounter();
    final billNumber = 'GL-$dateStr-${seq.toString().padLeft(4, '0')}';

    final invoiceItems = cartItems
        .map((c) => InvoiceItem(
              itemName: c.item.name,
              variantName: c.variant.name,
              quantity: c.quantity,
              unitPrice: c.variant.price,
              itemTotal: BillingCalculator.calculateItemTotal(c),
            ))
        .toList();

    final subtotal = BillingCalculator.calculateSubtotal(cartItems);
    final gstAmount = BillingCalculator.calculateGST(subtotal, BillingCalculator.gstRate);
    final grandTotal = BillingCalculator.calculateGrandTotal(subtotal, gstAmount);

    final invoice = Invoice(
      id: const Uuid().v4(),
      billNumber: billNumber,
      date: now,
      tableOrRoom: tableOrRoom,
      items: invoiceItems,
      subtotal: subtotal,
      gstRate: BillingCalculator.gstRate,
      gstAmount: gstAmount,
      grandTotal: grandTotal,
    );

    // Persist to storage
    await StorageService.saveInvoice(invoice);

    // Update in-memory state (newest first)
    state = [invoice, ...state];

    return invoice;
  }

  Future<void> deleteInvoice(String invoiceId) async {
    await StorageService.deleteInvoice(invoiceId);
    state = state.where((inv) => inv.id != invoiceId).toList();
  }

  Future<void> refresh() async {
    await _loadFromStorage();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Invoice>>((ref) {
  return OrderNotifier();
});
