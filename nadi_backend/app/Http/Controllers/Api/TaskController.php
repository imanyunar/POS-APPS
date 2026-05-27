<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTaskRequest;
use App\Http\Resources\TaskResource;
use App\Models\Activity;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index(Request $request)
    {
        $query = Task::where('user_id', $request->user()->id);

        if ($category = $request->category) {
            $query->where('category', $category);
        }

        $tasks = $query->orderBy('sort_order')->orderBy('created_at')->get();

        return response()->json([
            'success' => true,
            'message' => 'Tasks retrieved',
            'data' => TaskResource::collection($tasks),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreTaskRequest $request)
    {
        $task = Task::create([
            'user_id' => $request->user()->id,
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'due_date' => $request->dueDate,
            'sort_order' => $request->sortOrder ?? 0,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Task created',
            'data' => new TaskResource($task),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $task = Task::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Task retrieved',
            'data' => new TaskResource($task),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(StoreTaskRequest $request, string $id)
    {
        $task = Task::where('user_id', $request->user()->id)->findOrFail($id);
        $task->update([
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'due_date' => $request->dueDate,
            'sort_order' => $request->sortOrder ?? 0,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Task updated',
            'data' => new TaskResource($task),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $task = Task::where('user_id', $request->user()->id)->findOrFail($id);
        $task->delete();

        return response()->json([
            'success' => true,
            'message' => 'Task deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function toggle(Request $request, string $id)
    {
        $task = Task::where('user_id', $request->user()->id)->findOrFail($id);
        $task->update([
            'is_completed' => !$task->is_completed,
            'completed_at' => $task->is_completed ? null : now(),
        ]);

        if ($task->is_completed) {
            Activity::create([
                'user_id' => $request->user()->id,
                'type' => 'task_completed',
                'details' => ['task_id' => $task->id, 'title' => $task->title],
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Task toggled',
            'data' => new TaskResource($task),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
