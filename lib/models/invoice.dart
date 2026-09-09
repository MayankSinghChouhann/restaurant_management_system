import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class InvoiceItem {
  final String id;
  final String itemName;
  final String variantName;
  final int quantity;
  final int kitchenPrintedQuantity;
  final double unitPrice;
  final double itemTotal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InvoiceItem({
    required this.id,
    required this.itemName,
    required this.variantName,
    required this.quantity,
    this.kitchenPrintedQuantity = 0,
    required this.unitPrice,
    required this.itemTotal,
    this.createdAt,
    this.updatedAt,
  });

  InvoiceItem copyWith({
    String? id,
    String? itemName,
    String? variantName,
    int? quantity,
    int? kitchenPrintedQuantity,
    double? unitPrice,
    double? itemTotal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      variantName: variantName ?? this.variantName,
      quantity: quantity ?? this.quantity,
      kitchenPrintedQuantity: kitchenPrintedQuantity ?? this.kitchenPrintedQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
      itemTotal: itemTotal ?? this.itemTotal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemName': itemName,
        'variantName': variantName,
        'quantity': quantity,
        'kitchenPrintedQuantity': kitchenPrintedQuantity,
        'unitPrice': unitPrice,
        'itemTotal': itemTotal,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        id: json['id'] as String? ?? const Uuid().v4(),
        itemName: json['itemName'] as String,
        variantName: json['variantName'] as String,
        quantity: json['quantity'] as int,
        kitchenPrintedQuantity: json['kitchenPrintedQuantity'] as int? ?? json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        itemTotal: (json['itemTotal'] as num).toDouble(),
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
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
  final String status;
  final DateTime? closedAt;
  final DateTime? lastItemAddedAt;

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
    this.status = 'CLOSED',
    this.closedAt,
    this.lastItemAddedAt,
  });

  Invoice copyWith({
    String? id,
    String? billNumber,
    DateTime? date,
    String? tableOrRoom,
    List<InvoiceItem>? items,
    double? subtotal,
    double? gstRate,
    double? gstAmount,
    double? grandTotal,
    String? status,
    DateTime? closedAt,
    DateTime? lastItemAddedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      date: date ?? this.date,
      tableOrRoom: tableOrRoom ?? this.tableOrRoom,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      gstRate: gstRate ?? this.gstRate,
      gstAmount: gstAmount ?? this.gstAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      lastItemAddedAt: lastItemAddedAt ?? this.lastItemAddedAt,
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedTime => DateFormat('hh:mm a').format(date);
  
  bool get isExpired => status == 'OPEN' && DateTime.now().difference(date).inHours >= 1;
  bool get isEditable => status == 'OPEN' && !isExpired;

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
        'status': status,
        'closedAt': closedAt?.toIso8601String(),
        'lastItemAddedAt': lastItemAddedAt?.toIso8601String(),
      };

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.parse(json['date'] as String);
    return Invoice(
      id: json['id'] as String,
      billNumber: json['billNumber'] as String,
      date: parsedDate,
      tableOrRoom: json['tableOrRoom'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      gstRate: (json['gstRate'] as num).toDouble(),
      gstAmount: (json['gstAmount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      status: json['status'] as String? ?? 'CLOSED', // Backward compatible
      closedAt: json['closedAt'] != null ? DateTime.parse(json['closedAt'] as String) : null,
      lastItemAddedAt: json['lastItemAddedAt'] != null 
          ? DateTime.parse(json['lastItemAddedAt'] as String) 
          : parsedDate,
    );
  }
}
