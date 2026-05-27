<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreNoteRequest;
use App\Http\Resources\NoteResource;
use App\Models\Note;
use Illuminate\Http\Request;

class NoteController extends Controller
{
    public function index(Request $request)
    {
        $query = Note::where('user_id', $request->user()->id)->with('customer');

        if ($category = $request->category) {
            $query->where('category', $category);
        }

        $notes = $query->orderByDesc('is_pinned')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Notes retrieved',
            'data' => NoteResource::collection($notes),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreNoteRequest $request)
    {
        $note = Note::create([
            'user_id' => $request->user()->id,
            'customer_id' => $request->customerId,
            'title' => $request->title,
            'content' => $request->content,
            'category' => $request->category,
            'is_pinned' => $request->isPinned ?? false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Note created',
            'data' => new NoteResource($note->load('customer')),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $note = Note::where('user_id', $request->user()->id)->with('customer')->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Note retrieved',
            'data' => new NoteResource($note),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(StoreNoteRequest $request, string $id)
    {
        $note = Note::where('user_id', $request->user()->id)->findOrFail($id);
        $note->update([
            'title' => $request->title,
            'content' => $request->content,
            'category' => $request->category,
            'customer_id' => $request->customerId,
            'is_pinned' => $request->isPinned ?? false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Note updated',
            'data' => new NoteResource($note->load('customer')),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $note = Note::where('user_id', $request->user()->id)->findOrFail($id);
        $note->delete();

        return response()->json([
            'success' => true,
            'message' => 'Note deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
