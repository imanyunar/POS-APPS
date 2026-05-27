import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import '../task_list_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Tugas Harian'),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const ServeEmptyState(
              icon: Icons.check_box_rounded,
              title: 'Semua tugas selesai',
              subtitle: 'Tidak ada tugas yang perlu dikerjakan.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(taskListNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ServeCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (val) {
                            ref.read(taskListNotifierProvider.notifier).toggleTask(task.id, task.isCompleted);
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.title,
                            style: ServeTypography.bodyMedium(
                              color: task.isCompleted ? ServeColors.textMuted : ServeColors.textPrimary,
                            ).copyWith(
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Gagal memuat tugas', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/more/tasks/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
