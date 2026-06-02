import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/invoices/domain/invoice_model.dart';

class PdfGenerator {
  PdfGenerator._();

  static Future<Uint8List> generateInvoicePdf(InvoiceModel invoice) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SERVE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 22, color: PdfColors.orange700)),
                pw.Text(
                  invoice.invoiceNumber,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.Divider(thickness: 2, color: PdfColors.orange200),
          pw.SizedBox(height: 32),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TAGIHAN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Kepada: ${invoice.customerName.isEmpty ? "Umum" : invoice.customerName}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Status:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: invoice.status == 'paid'
                          ? PdfColors.green50
                          : PdfColors.orange50,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                    ),
                    child: pw.Text(
                      invoice.status == 'paid' ? 'LUNAS' : 'BELUM DIBAYAR',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color: invoice.status == 'paid' ? PdfColors.green700 : PdfColors.orange700,
                      ),
                    ),
                  ),
                  if (invoice.dueDate != null) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Jatuh tempo: ${invoice.dueDate}',
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                    ),
                  ],
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 32),

          pw.Table(
            border: pw.TableBorder(
              bottom: pw.BorderSide(color: PdfColors.grey300),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                children: [
                  _cell('Deskripsi', isHeader: true),
                  _cell('Qty', isHeader: true),
                  _cell('Harga', isHeader: true),
                  _cell('Total', isHeader: true),
                ],
              ),
              pw.TableRow(
                children: [
                  _cell('Invoice #${invoice.invoiceNumber}'),
                  _cell('1'),
                  _cell(ServeFormatters.rupiah(invoice.subtotal)),
                  _cell(ServeFormatters.rupiah(invoice.subtotal)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _summaryRow('Subtotal', ServeFormatters.rupiah(invoice.subtotal)),
                  _summaryRow('Pajak', ServeFormatters.rupiah(invoice.tax)),
                  pw.Divider(),
                  _summaryRow('Total', ServeFormatters.rupiah(invoice.total), isBold: true),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 40),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 16),
          pw.Text(
            'Terima kasih atas kepercayaan Anda.',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            'Serve - Business Operating System untuk UMKM Indonesia',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey400),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _cell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
