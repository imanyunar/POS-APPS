import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/invoice_repository.dart';
import '../domain/invoice_model.dart';

final invoiceDetailProvider = FutureProvider.autoDispose.family<InvoiceModel, String>((ref, id) async {
  return ref.watch(invoiceRepositoryProvider).fetchInvoice(id);
});
