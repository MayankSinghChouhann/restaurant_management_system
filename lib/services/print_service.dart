import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/invoice.dart';
import 'pdf_receipt_service.dart';

class PrintService {
  static Future<void> printInvoice(Invoice invoice) async {
    final pdfBytes = await PdfReceiptService.generateReceipt(invoice);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'GoldenLeaf_Bill_${invoice.billNumber}',
    );
  }

  static Future<void> shareInvoice(Invoice invoice) async {
    final pdfBytes = await PdfReceiptService.generateReceipt(invoice);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'GoldenLeaf_Bill_${invoice.billNumber}.pdf',
    );
  }
}
