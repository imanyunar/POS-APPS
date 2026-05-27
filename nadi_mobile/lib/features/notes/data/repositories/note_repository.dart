import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/notes/domain/note_model.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(dioClientProvider));
});

class NoteRepository {
  final DioClient _client;

  NoteRepository(this._client);

  Future<List<NoteModel>> fetchNotes() async {
    final response = await _client.dio.get(ApiEndpoints.notes);
    final apiResponse = ApiResponse<List<NoteModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<NoteModel> createNote(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.notes, data: data);
    final apiResponse = ApiResponse<NoteModel>.fromJson(
      response.data,
      (data) => NoteModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<NoteModel> updateNote(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.noteDetail(id), data: data);
    final apiResponse = ApiResponse<NoteModel>.fromJson(
      response.data,
      (data) => NoteModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteNote(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.noteDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
