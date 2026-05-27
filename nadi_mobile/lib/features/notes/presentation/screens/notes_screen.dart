import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import '../note_list_provider.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(noteListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const ServeEmptyState(
              icon: Icons.sticky_note_2_rounded,
              title: 'Belum ada catatan',
              subtitle: 'Simpan ide, informasi supplier, atau catatan penting di sini.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(noteListNotifierProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                final date = DateTime.tryParse(note.createdAt);
                final dateString = date != null ? ServeFormatters.dateShort(date) : '';
                
                return ServeCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: ServeTypography.h3(color: ServeColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            dateString,
                            style: ServeTypography.labelSmall(color: ServeColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: ServeTypography.bodyMedium(color: ServeColors.textMuted),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Gagal memuat catatan', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/more/notes/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

