import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/invoice.dart';

class PdfReceiptService {
  static Future<Uint8List> generateReceipt(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Receipt printer format (80mm)
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('HOTEL GOLDEN LEAF', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Center(
                child: pw.Text('RESTAURANT', style: const pw.TextStyle(fontSize: 14)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Bill No: ${invoice.billNumber}'),
              pw.Text('Date: ${invoice.formattedDate}'),
              pw.Text('Time: ${invoice.formattedTime}'),
              if (invoice.tableOrRoom != null) pw.Text('Table/Room: ${invoice.tableOrRoom}'),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), flex: 4),
                  pw.Expanded(child: pw.Text('Qty', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), flex: 1),
                  pw.Expanded(child: pw.Text('Rate', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), flex: 2),
                  pw.Expanded(child: pw.Text('Amount', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), flex: 2),
                ],
              ),
              pw.Divider(),
              ...invoice.items.map((item) {
                final String itemName = item.variantName == 'Regular' 
                    ? item.itemName 
                    : '${item.itemName} (${item.variantName})';
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(child: pw.Text(itemName), flex: 4),
                      pw.Expanded(child: pw.Text(item.quantity.toString(), textAlign: pw.TextAlign.center), flex: 1),
                      pw.Expanded(child: pw.Text(item.unitPrice.toStringAsFixed(2), textAlign: pw.TextAlign.right), flex: 2),
                      pw.Expanded(child: pw.Text(item.itemTotal.toStringAsFixed(2), textAlign: pw.TextAlign.right), flex: 2),
                    ],
                  ),
                );
              }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:'),
                  pw.Text(invoice.subtotal.toStringAsFixed(2)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GST @ ${invoice.gstRate.toStringAsFixed(0)}%:'),
                  pw.Text(invoice.gstAmount.toStringAsFixed(2)),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(invoice.grandTotal.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Thank You!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Center(
                child: pw.Text('Please Visit Again'),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
