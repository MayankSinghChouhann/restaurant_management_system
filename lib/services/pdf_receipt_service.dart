import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice.dart';

class PdfReceiptService {
  static Future<Uint8List> generateReceipt(Invoice invoice) async {
    final pdf = pw.Document();

    final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    const smallFont = pw.TextStyle(fontSize: 9);
    final boldSmall = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text('GOLDEN LEAF', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('CHUTNEY MARRY', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('Suddowala', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 4),
              pw.Text('GSTIN: 05AGMPR3418H2Z9', style: smallFont),
              pw.Text('Mobile: 7302731122', style: smallFont),
              pw.SizedBox(height: 8),
              pw.Divider(),

              // Bill info
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill No: ${invoice.billNumber}', style: smallFont),
                    pw.Text('Date: ${invoice.formattedDate}', style: smallFont),
                    pw.Text('Time: ${invoice.formattedTime}', style: smallFont),
                    if (invoice.tableOrRoom != null && invoice.tableOrRoom!.isNotEmpty)
                      pw.Text('Room/Table: ${invoice.tableOrRoom}', style: smallFont),
                  ],
                ),
              ),
              pw.Divider(),

              // Table header
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FixedColumnWidth(20),
                  2: const pw.FixedColumnWidth(48),
                  3: const pw.FixedColumnWidth(52),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Text('Item', style: boldSmall),
                    pw.Text('Qty', textAlign: pw.TextAlign.center, style: boldSmall),
                    pw.Text('Rate', textAlign: pw.TextAlign.right, style: boldSmall),
                    pw.Text('Amt', textAlign: pw.TextAlign.right, style: boldSmall),
                  ]),
                ],
              ),
              pw.Divider(),

              // Items
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FixedColumnWidth(20),
                  2: const pw.FixedColumnWidth(48),
                  3: const pw.FixedColumnWidth(52),
                },
                children: invoice.items.map((item) {
                  final String itemName = item.variantName == 'Regular'
                      ? item.itemName
                      : '${item.itemName}\n(${item.variantName})';
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(itemName, style: smallFont),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(
                        item.quantity.toString(),
                        textAlign: pw.TextAlign.center,
                        style: smallFont,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(
                        'Rs.${item.unitPrice.toStringAsFixed(2)}',
                        textAlign: pw.TextAlign.right,
                        style: smallFont,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(
                        'Rs.${item.itemTotal.toStringAsFixed(2)}',
                        textAlign: pw.TextAlign.right,
                        style: smallFont,
                      ),
                    ),
                  ]);
                }).toList(),
              ),
              pw.Divider(),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:', style: smallFont),
                  pw.Text('Rs.${invoice.subtotal.toStringAsFixed(2)}', style: smallFont),
                ],
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GST @ ${invoice.gstRate.toStringAsFixed(0)}%:', style: smallFont),
                  pw.Text('Rs.${invoice.gstAmount.toStringAsFixed(2)}', style: smallFont),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL:', style: bold),
                  pw.Text('Rs.${invoice.grandTotal.toStringAsFixed(2)}', style: bold),
                ],
              ),
              pw.SizedBox(height: 16),

              // Footer
              pw.Center(child: pw.Text('Thank You!', style: bold)),
              pw.Center(child: pw.Text('Please Visit Again', style: smallFont)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateKOT(Invoice invoice, String kotNumber) async {
    final pdf = pw.Document();

    final boldSmall = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
    const smallFont = pw.TextStyle(fontSize: 10);

    // Get unprinted items
    final unprintedItems = invoice.items.where((item) => item.quantity > item.kitchenPrintedQuantity).toList();

    if (unprintedItems.isEmpty) {
      throw Exception('No new items to print');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text('CHUTNEY MARRY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('KITCHEN ORDER', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Divider(),

              // Bill info
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (invoice.tableOrRoom != null && invoice.tableOrRoom!.isNotEmpty)
                      pw.Text('Room/Table: ${invoice.tableOrRoom}', style: boldSmall),
                    pw.Text('Time: ${DateFormat('hh:mm a').format(DateTime.now())}', style: smallFont),
                    pw.Text('KOT: $kotNumber', style: smallFont),
                  ],
                ),
              ),
              pw.Divider(),

              // Table header
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FixedColumnWidth(30),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Text('Item', style: boldSmall),
                    pw.Text('Qty', textAlign: pw.TextAlign.center, style: boldSmall),
                  ]),
                ],
              ),
              pw.Divider(),

              // Items
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FixedColumnWidth(30),
                },
                children: unprintedItems.map((item) {
                  final String itemName = item.variantName == 'Regular'
                      ? item.itemName
                      : '${item.itemName} (${item.variantName})';
                  final qtyToPrint = item.quantity - item.kitchenPrintedQuantity;
                  
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(itemName, style: smallFont),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        qtyToPrint.toString(),
                        textAlign: pw.TextAlign.center,
                        style: boldSmall,
                      ),
                    ),
                  ]);
                }).toList(),
              ),
              pw.Divider(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
