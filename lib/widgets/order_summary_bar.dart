import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../services/billing_calculator.dart';
import '../screens/cart_screen.dart';

class OrderSummaryBar extends ConsumerWidget {
  const OrderSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalItems =
        cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final grandTotal = BillingCalculator.calculateGrandTotal(
      BillingCalculator.calculateSubtotal(cartItems),
      BillingCalculator.calculateGST(
          BillingCalculator.calculateSubtotal(cartItems),
          BillingCalculator.gstRate),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$totalItems item${totalItems > 1 ? 's' : ''}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '₹${grandTotal.toStringAsFixed(2)} (incl. GST)',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13),
              ),
            ),
            const Row(
              children: [
                Text('View Cart',
                    style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios,
                    size: 12, color: Color(0xFFD4AF37)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
