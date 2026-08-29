import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/services/billing_calculator.dart';
import 'package:restaurant_app/models/cart_item.dart';
import 'package:restaurant_app/models/menu_item.dart';
import 'package:restaurant_app/models/menu_variant.dart';

void main() {
  group('BillingCalculator Tests', () {
    const variant1 = MenuVariant(id: 'v1', name: 'Plain', price: 30);
    const variant2 = MenuVariant(id: 'v2', name: 'Butter', price: 40);
    
    const item = MenuItem(
      id: '1',
      categoryId: 'c1',
      name: 'Roti',
      variants: [variant1, variant2],
    );

    test('calculateItemTotal', () {
      final cartItem = CartItem(item: item, variant: variant2, quantity: 2);
      expect(BillingCalculator.calculateItemTotal(cartItem), 80.0);
    });

    test('calculateSubtotal', () {
      final cartItems = [
        CartItem(item: item, variant: variant1, quantity: 2), // 60
        CartItem(item: item, variant: variant2, quantity: 1), // 40
      ];
      expect(BillingCalculator.calculateSubtotal(cartItems), 100.0);
    });

    test('calculateGST', () {
      expect(BillingCalculator.calculateGST(100.0, 5.0), 5.0);
    });

    test('calculateGrandTotal', () {
      expect(BillingCalculator.calculateGrandTotal(100.0, 5.0), 105.0);
    });
  });
}
