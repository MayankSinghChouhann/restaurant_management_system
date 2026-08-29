import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice.dart';
import '../providers/cart_provider.dart';
import '../services/print_service.dart';

class BillPreviewScreen extends ConsumerWidget {
  final Invoice invoice;
  final bool isHistory;

  const BillPreviewScreen({
    super.key,
    required this.invoice,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(isHistory ? 'Bill  ${invoice.billNumber}' : 'Bill Preview'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!isHistory) ref.read(cartProvider.notifier).clear();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Column(
        children: [
          // Scrollable bill body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Bill header — dark band
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C3E50),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'HOTEL GOLDEN LEAF',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'RESTAURANT',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                letterSpacing: 2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'www.hotelgoldenleafdehradun.com',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                    ),

                    // Bill meta info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        children: [
                          _BillInfoRow(
                              icon: Icons.receipt,
                              label: 'Bill No',
                              value: invoice.billNumber),
                          _BillInfoRow(
                              icon: Icons.calendar_today,
                              label: 'Date',
                              value: invoice.formattedDate),
                          _BillInfoRow(
                              icon: Icons.access_time,
                              label: 'Time',
                              value: invoice.formattedTime),
                          if (invoice.tableOrRoom != null &&
                              invoice.tableOrRoom!.isNotEmpty)
                            _BillInfoRow(
                                icon: Icons.hotel,
                                label: 'Room No',
                                value: invoice.tableOrRoom!),
                          const SizedBox(height: 12),
                          const Divider(thickness: 1.5),
                        ],
                      ),
                    ),

                    // Column headers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text('ITEM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ),
                          SizedBox(
                            width: 30,
                            child: Text('QTY',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text('RATE',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ),
                          SizedBox(
                            width: 70,
                            child: Text('AMOUNT',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(),
                    ),

                    // Line items
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: invoice.items.map((item) {
                          final name = item.variantName == 'Regular'
                              ? item.itemName
                              : '${item.itemName} (${item.variantName})';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(name,
                                      style: const TextStyle(fontSize: 13)),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    '₹${item.unitPrice.toStringAsFixed(0)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    '₹${item.itemTotal.toStringAsFixed(2)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Totals section
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _TotalRow(
                              label: 'Subtotal',
                              amount: invoice.subtotal,
                              isBold: false),
                          const SizedBox(height: 6),
                          _TotalRow(
                              label:
                                  'GST @ ${invoice.gstRate.toStringAsFixed(0)}%',
                              amount: invoice.gstAmount,
                              isBold: false),
                          const Divider(height: 16),
                          _TotalRow(
                              label: 'GRAND TOTAL',
                              amount: invoice.grandTotal,
                              isBold: true,
                              fontSize: 17),
                        ],
                      ),
                    ),

                    // Footer
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Text('Thank You!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('Please Visit Again',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('www.hotelgoldenleafdehradun.com',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.print, size: 18),
                        label: const Text('PRINT BILL'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF2C3E50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          try {
                            await PrintService.printInvoice(invoice);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Unable to print. Try Sharing.')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('SHARE PDF'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFF2C3E50)),
                          foregroundColor: const Color(0xFF2C3E50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          try {
                            await PrintService.shareInvoice(invoice);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Unable to share receipt.')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (!isHistory) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ref.read(cartProvider.notifier).clear();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        'NEW ORDER',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BillInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _BillInfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 6),
          Text('$label: ',
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final double fontSize;
  const _TotalRow(
      {required this.label,
      required this.amount,
      required this.isBold,
      this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF2C3E50) : null),
        ),
      ],
    );
  }
}
