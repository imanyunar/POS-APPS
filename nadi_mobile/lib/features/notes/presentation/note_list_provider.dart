import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/note_repository.dart';
import '../domain/note_model.dart';

part 'note_list_provider.g.dart';

@riverpod
class NoteListNotifier extends _$NoteListNotifier {
  @override
  FutureOr<List<NoteModel>> build() async {
    return ref.read(noteRepositoryProvider).fetchNotes();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(noteRepositoryProvider).fetchNotes(),
    );
  }

  Future<void> createNote(Map<String, dynamic> data) async {
    await ref.read(noteRepositoryProvider).createNote(data);
    await refresh();
  }

  Future<void> updateNote(String id, Map<String, dynamic> data) async {
    await ref.read(noteRepositoryProvider).updateNote(id, data);
    await refresh();
  }

  Future<void> deleteNote(String id) async {
    await ref.read(noteRepositoryProvider).deleteNote(id);
    await refresh();
  }
}
