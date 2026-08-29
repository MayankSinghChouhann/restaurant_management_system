import 'package:intl/intl.dart';

class InvoiceItem {
  final String itemName;
  final String variantName;
  final int quantity;
  final double unitPrice;
  final double itemTotal;

  const InvoiceItem({
    required this.itemName,
    required this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.itemTotal,
  });
}

class Invoice {
  final String id;
  final String billNumber;
  final DateTime date;
  final String? tableOrRoom;
  final List<InvoiceItem> items;
  final double subtotal;
  final double gstRate;
  final double gstAmount;
  final double grandTotal;

  const Invoice({
    required this.id,
    required this.billNumber,
    required this.date,
    this.tableOrRoom,
    required this.items,
    required this.subtotal,
    required this.gstRate,
    required this.gstAmount,
    required this.grandTotal,
  });

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedTime => DateFormat('hh:mm a').format(date);
}
