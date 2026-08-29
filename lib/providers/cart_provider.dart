import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/menu_variant.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem item, MenuVariant variant, {int quantity = 1}) {
    if (quantity <= 0) return;

    final existingIndex = state.indexWhere(
      (c) => c.item.id == item.id && c.variant.id == variant.id,
    );

    if (existingIndex >= 0) {
      // Item exists, update quantity
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(quantity: existingItem.quantity + quantity);
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // New item
      state = [...state, CartItem(item: item, variant: variant, quantity: quantity)];
    }
  }

  void updateQuantity(MenuItem item, MenuVariant variant, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item, variant);
      return;
    }

    final existingIndex = state.indexWhere(
      (c) => c.item.id == item.id && c.variant.id == variant.id,
    );

    if (existingIndex >= 0) {
      final updatedItem = state[existingIndex].copyWith(quantity: newQuantity);
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    }
  }

  void removeItem(MenuItem item, MenuVariant variant) {
    state = state.where((c) => !(c.item.id == item.id && c.variant.id == variant.id)).toList();
  }

  void clear() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
