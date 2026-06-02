import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/invoices/presentation/invoice_detail_provider.dart';
import 'package:serve_app/features/invoices/presentation/invoice_list_provider.dart';
import 'package:serve_app/features/invoices/domain/invoice_model.dart';
import '../../utils/pdf_generator.dart';
import 'package:printing/printing.dart';

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  Future<void> _markAsPaid() async {
    try {
      await ref.read(invoiceListNotifierProvider.notifier).markPaid(widget.invoiceId);
      ref.invalidate(invoiceDetailProvider(widget.invoiceId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tagihan ditandai Lunas'), backgroundColor: ServeColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status: $e'), backgroundColor: ServeColors.danger),
        );
      }
    }
  }

  Future<void> _deleteInvoice() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tagihan?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Hapus', style: TextStyle(color: ServeColors.danger))
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(invoiceListNotifierProvider.notifier).deleteInvoice(widget.invoiceId);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tagihan dihapus'), backgroundColor: ServeColors.success),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: ServeColors.danger),
          );
        }
      }
    }
  }

  String _buildWhatsAppMessage(InvoiceModel invoice) {
    final status = invoice.status == 'paid' ? 'LUNAS' : 'BELUM DIBAYAR';
    final greeting = ServeFormatters.greeting();

    return '''$greeting, ${invoice.customerName.isEmpty ? "Bapak/Ibu" : invoice.customerName}

Berikut invoice untuk pesanan Anda:

📄 No. Invoice: ${invoice.invoiceNumber}
💰 Total: ${ServeFormatters.rupiah(invoice.total)}
📌 Status: $status
${invoice.dueDate != null ? "📅 Jatuh tempo: ${invoice.dueDate}" : ""}

Pembayaran dapat dilakukan via transfer ke rekening:
🏦 Bank Contoh
📱 Rek. 1234 5678 9012
Atas Nama: Serve Business

Konfirmasi pembayaran dengan membalas pesan ini.

Terima kasih! 🙏''';
  }

  Future<void> _shareToWhatsApp(InvoiceModel invoice) async {
    final message = _buildWhatsAppMessage(invoice);
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://api.whatsapp.com/send?text=$encoded');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await Share.share(message, subject: 'Invoice ${invoice.invoiceNumber}');
      }
    } catch (e) {
      await Share.share(message, subject: 'Invoice ${invoice.invoiceNumber}');
    }
  }

  String _whatsAppButtonLabel(InvoiceModel invoice) {
    return invoice.status == 'paid'
        ? 'Kirim Ulang Invoice via WA'
        : 'Bagikan Invoice via WA';
  }

  @override
  Widget build(BuildContext context) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(widget.invoiceId));

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Detail Tagihan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ServeColors.danger),
            onPressed: _deleteInvoice,
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: invoiceAsync.when(
        data: (invoice) {
          final bool isUnpaid = invoice.status == 'unpaid' || invoice.status == 'overdue';
          final dueDate = invoice.dueDate != null ? DateTime.tryParse(invoice.dueDate!) : null;

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(invoiceDetailProvider(widget.invoiceId)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                // --- Stripe-style Receipt ---
                _StripeReceipt(
                  invoice: invoice,
                  isUnpaid: isUnpaid,
                  dueDate: dueDate,
                ),
                const SizedBox(height: 24),

                // --- Action Buttons ---
                FilledButton.icon(
                  onPressed: () => _shareToWhatsApp(invoice),
                  icon: const Icon(Icons.share_rounded),
                  label: Text(_whatsAppButtonLabel(invoice)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                if (isUnpaid) ...[
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _markAsPaid,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Tandai Lunas'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ServeColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final pdfBytes = await PdfGenerator.generateInvoicePdf(invoice);
                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename: 'invoice_${invoice.invoiceNumber}.pdf',
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('Simpan sebagai PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat detail: $err')),
      ),
    );
  }
}

class _StripeReceipt extends StatelessWidget {
  final InvoiceModel invoice;
  final bool isUnpaid;
  final DateTime? dueDate;

  const _StripeReceipt({
    required this.invoice,
    required this.isUnpaid,
    this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Receipt Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: const BoxDecoration(
              color: ServeColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Icon(Icons.receipt_rounded, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  invoice.invoiceNumber,
                  style: ServeTypography.h2(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    invoice.status.toUpperCase(),
                    style: ServeTypography.labelSmall(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Receipt Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Customer
                _ReceiptRow(
                  icon: Icons.person_rounded,
                  label: 'Pelanggan',
                  value: invoice.customerName.isEmpty ? 'Umum' : invoice.customerName,
                ),
                const Divider(height: 24),

                // Subtotal
                _ReceiptRow(
                  icon: Icons.shopping_cart_rounded,
                  label: 'Subtotal',
                  value: ServeFormatters.rupiah(invoice.subtotal),
                ),
                const Divider(height: 24),

                // Tax
                _ReceiptRow(
                  icon: Icons.percent_rounded,
                  label: 'Pajak',
                  value: ServeFormatters.rupiah(invoice.tax),
                ),
                const Divider(height: 24),

                // Total (highlighted)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ServeColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ServeColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.paid_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text('Total Tagihan', style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
                      const Spacer(),
                      Text(
                        ServeFormatters.rupiah(invoice.total),
                        style: ServeTypography.h2(color: ServeColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Due date
                if (dueDate != null)
                  _ReceiptRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Jatuh Tempo',
                    value: ServeFormatters.dateIndonesian(dueDate!),
                    valueColor: isUnpaid ? ServeColors.danger : null,
                  ),

                // Divider dots
                _DottedDivider(),
                const SizedBox(height: 8),

                Text(
                  'Terima kasih atas kepercayaan Anda',
                  style: ServeTypography.labelSmall(color: ServeColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ReceiptRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ServeColors.textMuted),
        const SizedBox(width: 10),
        Text(label, style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
        const Spacer(),
        Text(
          value,
          style: ServeTypography.bodyMedium(color: valueColor ?? ServeColors.textPrimary),
        ),
      ],
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 2),
        painter: _DottedLinePainter(),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ServeColors.border
      ..strokeWidth = 1.5;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
