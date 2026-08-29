import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice.dart';
import '../providers/cart_provider.dart';
import '../services/print_service.dart';

class BillPreviewScreen extends ConsumerWidget {
  final Invoice invoice;

  const BillPreviewScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Preview'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(cartProvider.notifier).clear();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text('HOTEL GOLDEN LEAF', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    const Center(child: Text('RESTAURANT BILL')),
                    const SizedBox(height: 16),
                    Text('Bill No: ${invoice.billNumber}'),
                    Text('Date: ${invoice.formattedDate}'),
                    Text('Time: ${invoice.formattedTime}'),
                    if (invoice.tableOrRoom != null) Text('Table/Room: ${invoice.tableOrRoom}'),
                    const Divider(thickness: 2),
                    const Row(
                      children: [
                        Expanded(flex: 4, child: Text('ITEM', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 1, child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('RATE', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('AMOUNT', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const Divider(thickness: 2),
                    ...invoice.items.map((item) {
                      final itemName = item.variantName == 'Regular' ? item.itemName : '${item.itemName} (${item.variantName})';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 4, child: Text(itemName)),
                            Expanded(flex: 1, child: Text('${item.quantity}', textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text(item.unitPrice.toStringAsFixed(2), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text(item.itemTotal.toStringAsFixed(2), textAlign: TextAlign.right)),
                          ],
                        ),
                      );
                    }),
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('₹${invoice.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GST @ ${invoice.gstRate.toStringAsFixed(0)}%'),
                        Text('₹${invoice.gstAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('₹${invoice.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('PRINT BILL'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            await PrintService.printInvoice(invoice);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to print receipt. Try Sharing.')));
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('SHARE PDF'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          try {
                            await PrintService.shareInvoice(invoice);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to share receipt.')));
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      ref.read(cartProvider.notifier).clear();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('NEW ORDER'),
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

