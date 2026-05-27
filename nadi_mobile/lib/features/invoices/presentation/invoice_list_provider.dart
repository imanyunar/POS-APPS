import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/invoice_repository.dart';
import '../domain/invoice_model.dart';

part 'invoice_list_provider.g.dart';

@riverpod
class InvoiceListNotifier extends _$InvoiceListNotifier {
  @override
  FutureOr<List<InvoiceModel>> build() async {
    return ref.read(invoiceRepositoryProvider).fetchInvoices();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(invoiceRepositoryProvider).fetchInvoices(),
    );
  }

  Future<void> createInvoice(Map<String, dynamic> data) async {
    await ref.read(invoiceRepositoryProvider).createInvoice(data);
    await refresh();
  }

  Future<void> markPaid(String id) async {
    final previousState = state;
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.map((inv) => inv.id == id ? inv.copyWith(status: 'paid') : inv).toList(),
      );
    }
    try {
      await ref.read(invoiceRepositoryProvider).markPaid(id);
    } catch (e) {
      state = previousState;
    }
  }

  Future<void> deleteInvoice(String id) async {
    await ref.read(invoiceRepositoryProvider).deleteInvoice(id);
    await refresh();
  }
}
