import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/invoice.dart';
import '../models/cart_item.dart';
import '../services/billing_calculator.dart';

class OrderNotifier extends StateNotifier<List<Invoice>> {
  OrderNotifier() : super([]);

  int _billCounter = 1;

  Invoice generateInvoice(List<CartItem> cartItems, {String? tableOrRoom}) {
    if (cartItems.isEmpty) {
      throw Exception('Cannot generate invoice for empty cart');
    }

    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final seqStr = _billCounter.toString().padLeft(4, '0');
    final billNumber = 'GL-$dateStr-$seqStr';
    _billCounter++;

    final invoiceItems = cartItems.map((cartItem) => InvoiceItem(
      itemName: cartItem.item.name,
      variantName: cartItem.variant.name,
      quantity: cartItem.quantity,
      unitPrice: cartItem.variant.price,
      itemTotal: BillingCalculator.calculateItemTotal(cartItem),
    )).toList();

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

    // Save to state (in-memory persistence for this session)
    state = [...state, invoice];

    return invoice;
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Invoice>>((ref) {
  return OrderNotifier();
});
