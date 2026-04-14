import 'package:todo_app/models/todo_model.dart';

class TodoSortUtils {
  // Sort pending todos: Overdue first, then by date, then no date
  static List<TodoModel> sortPendingTodos(List<TodoModel> pendingTodos) {
    final sorted = List<TodoModel>.from(pendingTodos);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  static bool isOverdue(TodoModel todo) {
    return todo.dueDate != null &&
        todo.dueDate!.isBefore(DateTime.now()) &&
        !todo.isDone;
  }
}
