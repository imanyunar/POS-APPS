import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/invoices/domain/invoice_model.dart';
import '../invoice_list_provider.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoiceListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => context.go('/invoices/create'),
            tooltip: 'Buat Invoice Baru',
          ),
        ],
      ),
      body: invoicesAsync.when(
        data: (invoices) {
          if (invoices.isEmpty) {
            return ServeEmptyState(
              icon: Icons.receipt_rounded,
              title: 'Belum ada Invoice',
              subtitle: 'Buat invoice pertama Anda dan bagikan ke pelanggan.',
              actionLabel: 'Buat Invoice',
              onAction: () => context.go('/invoices/create'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(invoiceListNotifierProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: invoices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _InvoiceCard(invoice: invoices[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat invoice', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.read(invoiceListNotifierProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceCard({required this.invoice});

  ServeBadge get _badge => switch (invoice.status) {
        'paid' => ServeBadge.paid(),
        'unpaid' => ServeBadge.unpaid(),
        'overdue' => ServeBadge.overdue(),
        'draft' => ServeBadge.pending(),
        _ => ServeBadge.pending(),
      };

  @override
  Widget build(BuildContext context) {
    final dueDate = invoice.dueDate != null ? DateTime.tryParse(invoice.dueDate!) : null;

    return ServeCard(
      onTap: () => context.go('/invoices/${invoice.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(invoice.invoiceNumber, style: ServeTypography.labelSmall(color: ServeColors.textSecondary)),
              _badge,
            ],
          ),
          const SizedBox(height: 12),
          Text(invoice.customerName, style: ServeTypography.h3(color: ServeColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (dueDate != null)
                Text('Jatuh tempo: ${ServeFormatters.dateShort(dueDate)}', 
                  style: ServeTypography.bodySmall(color: invoice.status == 'overdue' ? ServeColors.danger : ServeColors.textSecondary)),
              Text(ServeFormatters.rupiah(invoice.total), 
                style: ServeTypography.labelLarge(color: ServeColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}
