import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../services/billing_calculator.dart';
import 'bill_preview_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _roomController = TextEditingController();

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: const Center(child: Text('Your cart is empty.')),
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
            onPressed: () => ref.read(cartProvider.notifier).clear(),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final cItem = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                              Text(
                                cItem.variant.name,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            Text('₹${cItem.variant.price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      // Quantity stepper
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
                                ref.read(cartProvider.notifier).updateQuantity(
                                    cItem.item, cItem.variant, cItem.quantity - 1);
                              },
                            ),
                            Text('${cItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(
                                    cItem.item, cItem.variant, cItem.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 70,
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

          // Bottom summary + Room Number + Generate Bill
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Number field
                TextField(
                  controller: _roomController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Room Number (optional)',
                    hintText: 'e.g. 101, 202...',
                    prefixIcon: const Icon(Icons.hotel),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtotal row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('₹${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 4),

                // GST row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('GST @ ${BillingCalculator.gstRate.toStringAsFixed(0)}%'),
                    Text('₹${gstAmount.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(height: 20),

                // Grand Total row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('GRAND TOTAL',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      '₹${grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Generate Bill Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () async {
                      final roomNumber = _roomController.text.trim();
                      try {
                        final invoice = await ref.read(orderProvider.notifier).generateInvoice(
                          cartItems,
                          tableOrRoom: roomNumber.isNotEmpty ? roomNumber : null,
                        );
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BillPreviewScreen(invoice: invoice),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: const Text(
                      'GENERATE BILL',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
