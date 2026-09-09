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
              id: const Uuid().v4(),
              itemName: c.item.name,
              variantName: c.variant.name,
              quantity: c.quantity,
              kitchenPrintedQuantity: 0,
              unitPrice: c.variant.price,
              itemTotal: BillingCalculator.calculateItemTotal(c),
              createdAt: now,
              updatedAt: now,
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
      status: 'OPEN',
      lastItemAddedAt: now,
    );

    // Persist to storage
    await StorageService.saveInvoice(invoice);

    // Update in-memory state (newest first)
    state = [invoice, ...state];

    return invoice;
  }

  Future<Invoice> appendItemsToOrder(String orderId, List<CartItem> cartItems) async {
    final orderIndex = state.indexWhere((inv) => inv.id == orderId);
    if (orderIndex < 0) throw Exception('Order not found');
    
    var order = state[orderIndex];
    if (!order.isEditable) throw Exception('Order cannot be edited');

    final now = DateTime.now();
    final List<InvoiceItem> updatedItems = List.from(order.items);

    for (final cItem in cartItems) {
      final existingIndex = updatedItems.indexWhere(
        (i) => i.itemName == cItem.item.name && i.variantName == cItem.variant.name
      );

      if (existingIndex >= 0) {
        final existing = updatedItems[existingIndex];
        final newQuantity = existing.quantity + cItem.quantity;
        updatedItems[existingIndex] = existing.copyWith(
          quantity: newQuantity,
          itemTotal: newQuantity * existing.unitPrice,
          updatedAt: now,
        );
      } else {
        updatedItems.add(InvoiceItem(
          id: const Uuid().v4(),
          itemName: cItem.item.name,
          variantName: cItem.variant.name,
          quantity: cItem.quantity,
          kitchenPrintedQuantity: 0,
          unitPrice: cItem.variant.price,
          itemTotal: cItem.quantity * cItem.variant.price,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    final subtotal = updatedItems.fold<double>(0, (sum, item) => sum + item.itemTotal);
    final gstAmount = BillingCalculator.calculateGST(subtotal, BillingCalculator.gstRate);
    final grandTotal = BillingCalculator.calculateGrandTotal(subtotal, gstAmount);

    order = order.copyWith(
      items: updatedItems,
      subtotal: subtotal,
      gstAmount: gstAmount,
      grandTotal: grandTotal,
      lastItemAddedAt: now,
    );

    await StorageService.saveInvoice(order);
    
    final newState = List<Invoice>.from(state);
    newState[orderIndex] = order;
    state = newState;

    return order;
  }

  Future<void> updateItemQuantity(String orderId, String itemId, int newQuantity) async {
    final orderIndex = state.indexWhere((inv) => inv.id == orderId);
    if (orderIndex < 0) return;
    
    var order = state[orderIndex];
    if (!order.isEditable) throw Exception('Order cannot be edited');

    final now = DateTime.now();
    List<InvoiceItem> updatedItems = List.from(order.items);
    final itemIndex = updatedItems.indexWhere((i) => i.id == itemId);
    
    if (itemIndex < 0) return;

    final existing = updatedItems[itemIndex];
    
    if (newQuantity <= 0) {
      updatedItems.removeAt(itemIndex);
    } else {
      updatedItems[itemIndex] = existing.copyWith(
        quantity: newQuantity,
        itemTotal: newQuantity * existing.unitPrice,
        updatedAt: now,
      );
    }

    final subtotal = updatedItems.fold<double>(0, (sum, item) => sum + item.itemTotal);
    final gstAmount = BillingCalculator.calculateGST(subtotal, BillingCalculator.gstRate);
    final grandTotal = BillingCalculator.calculateGrandTotal(subtotal, gstAmount);

    order = order.copyWith(
      items: updatedItems,
      subtotal: subtotal,
      gstAmount: gstAmount,
      grandTotal: grandTotal,
      lastItemAddedAt: now,
    );

    await StorageService.saveInvoice(order);
    
    final newState = List<Invoice>.from(state);
    newState[orderIndex] = order;
    state = newState;
  }

  Future<void> closeOrder(String orderId) async {
    final orderIndex = state.indexWhere((inv) => inv.id == orderId);
    if (orderIndex < 0) return;
    
    var order = state[orderIndex];
    order = order.copyWith(status: 'CLOSED', closedAt: DateTime.now());
    
    await StorageService.saveInvoice(order);
    
    final newState = List<Invoice>.from(state);
    newState[orderIndex] = order;
    state = newState;
  }

  Future<void> markKOTPrinted(String orderId) async {
    final orderIndex = state.indexWhere((inv) => inv.id == orderId);
    if (orderIndex < 0) return;
    
    var order = state[orderIndex];
    
    final updatedItems = order.items.map((item) {
      if (item.quantity > item.kitchenPrintedQuantity) {
        return item.copyWith(kitchenPrintedQuantity: item.quantity);
      }
      return item;
    }).toList();

    order = order.copyWith(items: updatedItems);
    
    await StorageService.saveInvoice(order);
    
    final newState = List<Invoice>.from(state);
    newState[orderIndex] = order;
    state = newState;
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
