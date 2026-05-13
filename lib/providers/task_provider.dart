import 'package:flutter/foundation.dart';
import '../models/task_dto.dart';
import '../services/api_service.dart';

enum TaskStatus { initial, loading, success, error }

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  TaskStatus status = TaskStatus.initial;
  String errorMessage = '';
  int nextId = 1;

  final ApiService api = ApiService();

  Future<void> fetchTasks() async {
    status = TaskStatus.loading;
    notifyListeners();

    try {
      tasks = await api.fetchTasks();
      status = TaskStatus.success;
    } catch (e) {
      status = TaskStatus.error;
      errorMessage = 'Failed to load tasks';
    }

    notifyListeners();
  }

  Future<bool> addTask(String title) async {
    String t = title.trim();

    if (t.isEmpty) {
      status = TaskStatus.error;
      errorMessage = 'Title is empty';
      notifyListeners();
      return false;
    }

    try {
      Task newTask = await api.createTask(t);
      tasks.add(newTask);
      status = TaskStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      status = TaskStatus.error;
      errorMessage = 'Failed to add task';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editTask(int id, String newTitle) async {
    String t = newTitle.trim();

    if (t.isEmpty) {
      status = TaskStatus.error;
      errorMessage = 'Title is empty';
      notifyListeners();
      return false;
    }

    try {
      Task updated = await api.updateTaskTitle(id, t);

      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].id == id) {
          tasks[i] = updated;
          break;
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      status = TaskStatus.error;
      errorMessage = 'Failed to update task';
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleTask(int id) async {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].id == id) {
        try {
          Task updatedStatus = await api.toggleTaskStatus(id, !tasks[i].done);
          tasks[i] = tasks[i].copyWith(done: updatedStatus.done);
          notifyListeners();
        } catch (e) {
          status = TaskStatus.error;
          errorMessage = 'Failed to update status';
          notifyListeners();
        }
        return;
      }
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await api.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      status = TaskStatus.error;
      errorMessage = 'Failed to delete task';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    errorMessage = '';
    status = TaskStatus.success;
    notifyListeners();
  }

  bool get isLoading => status == TaskStatus.loading;
  bool get hasError => status == TaskStatus.error;
}