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

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'variantName': variantName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'itemTotal': itemTotal,
      };

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        itemName: json['itemName'] as String,
        variantName: json['variantName'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        itemTotal: (json['itemTotal'] as num).toDouble(),
      );
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'billNumber': billNumber,
        'date': date.toIso8601String(),
        'tableOrRoom': tableOrRoom,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'gstRate': gstRate,
        'gstAmount': gstAmount,
        'grandTotal': grandTotal,
      };

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        billNumber: json['billNumber'] as String,
        date: DateTime.parse(json['date'] as String),
        tableOrRoom: json['tableOrRoom'] as String?,
        items: (json['items'] as List<dynamic>)
            .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        gstRate: (json['gstRate'] as num).toDouble(),
        gstAmount: (json['gstAmount'] as num).toDouble(),
        grandTotal: (json['grandTotal'] as num).toDouble(),
      );
}
