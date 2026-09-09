import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';
import '../providers/order_provider.dart';
import '../services/print_service.dart';
import '../services/storage_service.dart';
import 'bill_preview_screen.dart';

class ActiveOrderScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ActiveOrderScreen({super.key, required this.orderId});

  @override
  ConsumerState<ActiveOrderScreen> createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends ConsumerState<ActiveOrderScreen> {
  bool _isPrinting = false;

  void _printKOT(Invoice invoice) async {
    final unprinted = invoice.items.where((i) => i.quantity > i.kitchenPrintedQuantity).toList();
    if (unprinted.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No new kitchen items to print.')),
      );
      return;
    }

    setState(() {
      _isPrinting = true;
    });

    try {
      final kotNumberInt = await StorageService.nextKOTCounter();
      final kotNumber = 'KOT-${kotNumberInt.toString().padLeft(6, '0')}';

      await PrintService.printKOT(invoice, kotNumber);
      
      // Update DB after successful print
      if (mounted) {
        await ref.read(orderProvider.notifier).markKOTPrinted(invoice.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('KOT $kotNumber printed successfully.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to print KOT: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  void _closeBill(Invoice invoice) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close this bill?'),
        content: const Text('After closing the bill, items and quantities cannot be edited.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Close Bill', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(orderProvider.notifier).closeOrder(invoice.id);
      if (mounted) {
        // Navigate to final receipt
        final updatedInvoice = ref.read(orderProvider).firstWhere((inv) => inv.id == invoice.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BillPreviewScreen(invoice: updatedInvoice),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderList = ref.watch(orderProvider);
    final invoiceIndex = orderList.indexWhere((inv) => inv.id == widget.orderId);
    
    if (invoiceIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Not Found')),
        body: const Center(child: Text('This order no longer exists.')),
      );
    }

    final invoice = orderList[invoiceIndex];
    
    if (invoice.status == 'CLOSED') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BillPreviewScreen(invoice: invoice, isHistory: true),
          ),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final editableUntil = invoice.date.add(const Duration(hours: 1));
    final hasUnprinted = invoice.items.any((i) => i.quantity > i.kitchenPrintedQuantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Order'),
      ),
      body: Column(
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueGrey.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ${invoice.billNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (invoice.tableOrRoom != null)
                      Text('Room/Table: ${invoice.tableOrRoom}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Created: ${DateFormat('hh:mm a').format(invoice.date)}'),
                    Text('Editable Until: ${DateFormat('hh:mm a').format(editableUntil)}', 
                        style: TextStyle(color: invoice.isExpired ? Colors.red : Colors.green.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          
          if (invoice.isExpired)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: const Text('Editing period has expired. Please close the bill.', 
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),

          // Items list
          Expanded(
            child: ListView.separated(
              itemCount: invoice.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                final isUnprinted = item.quantity > item.kitchenPrintedQuantity;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.variantName == 'Regular' ? item.itemName : '${item.itemName} (${item.variantName})',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('₹${item.unitPrice.toStringAsFixed(2)}  •  Printed: ${item.kitchenPrintedQuantity}', 
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            if (isUnprinted)
                              Text('Unprinted: ${item.quantity - item.kitchenPrintedQuantity}', 
                                  style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      
                      // Quantity control
                      if (invoice.isEditable)
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
                                  ref.read(orderProvider.notifier).updateItemQuantity(invoice.id, item.id, item.quantity - 1);
                                },
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: () {
                                  ref.read(orderProvider.notifier).updateItemQuantity(invoice.id, item.id, item.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        )
                      else
                        Text('Qty: ${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 70,
                        child: Text(
                          '₹${item.itemTotal.toStringAsFixed(2)}',
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

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Running Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('₹${invoice.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('Print Kitchen Receipt'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: hasUnprinted ? Colors.orange.shade800 : Colors.grey,
                          side: BorderSide(color: hasUnprinted ? Colors.orange.shade800 : Colors.grey),
                        ),
                        onPressed: (_isPrinting || !hasUnprinted) ? null : () => _printKOT(invoice),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (invoice.isEditable) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add Items'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Close Bill'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blueGrey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _closeBill(invoice),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
