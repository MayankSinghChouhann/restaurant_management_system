import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../services/billing_calculator.dart';
import 'bill_preview_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: const Center(
          child: Text('Your cart is empty.'),
        ),
      );
    }

    final subtotal = BillingCalculator.calculateSubtotal(cartItems);
    final gstAmount = BillingCalculator.calculateGST(subtotal, BillingCalculator.gstRate);
    final grandTotal = BillingCalculator.calculateGrandTotal(subtotal, gstAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final cItem = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cItem.item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (cItem.item.hasVariants)
                              Text(cItem.variant.name, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text('₹${cItem.variant.price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(cItem.item, cItem.variant, cItem.quantity - 1);
                              },
                            ),
                            Text('${cItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(cItem.item, cItem.variant, cItem.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '₹${cItem.total.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('₹${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('GST @ ${BillingCalculator.gstRate.toStringAsFixed(0)}%'),
                    Text('₹${gstAmount.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('₹${grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      try {
                        final invoice = ref.read(orderProvider.notifier).generateInvoice(cartItems);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => BillPreviewScreen(invoice: invoice)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: const Text('GENERATE BILL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
