import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/app_colors.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/todo_sort_utils.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final DatabaseService databaseService;
  final Function(TodoModel) onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.databaseService,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = TodoSortUtils.isOverdue(todo);

    return Dismissible(
      key: Key(todo.id),
      background: _buildEditBackground(),
      secondaryBackground: _buildDeleteBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit(todo);
          return false;
        }
        return true;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          databaseService.deleteTodo(todo.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Checkbox(
            value: todo.isDone,
            activeColor: AppColors.sucess,
            shape: const CircleBorder(),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
            onChanged: (bool? value) {
              if (value != null) {
                databaseService.updateTodoStatus(todo.id, value);
              }
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              color: todo.isDone
                  ? AppColors.textSecondary.withValues(alpha: 0.6)
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: todo.dueDate != null
              ? _buildSubtitleWithDate(isOverdue)
              : null,
        ),
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.sucess,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24),
      child: const Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Edit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSubtitleWithDate(bool isOverdue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: isOverdue ? AppColors.error : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            DateFormat('MMM d, yyyy').format(todo.dueDate!),
            style: TextStyle(
              color: isOverdue ? AppColors.error : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isOverdue ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isOverdue) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'OVERDUE',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
