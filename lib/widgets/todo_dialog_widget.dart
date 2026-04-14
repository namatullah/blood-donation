import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/app_colors.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/database_service.dart';

class TodoDialogWidget extends StatefulWidget {
  final DatabaseService databaseService;
  final TodoModel? todo;

  const TodoDialogWidget({super.key, required this.databaseService, this.todo});

  @override
  State<TodoDialogWidget> createState() => _TodoDialogWidgetState();
}

class _TodoDialogWidgetState extends State<TodoDialogWidget> {
  late TextEditingController titleController;
  late DateTime? selectedDate;
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.todo != null;
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    selectedDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Task' : 'Add New Task',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: isEditing
                    ? 'Enter todo title'
                    : 'What needs to be done?',
                prefixIcon: Icon(
                  isEditing ? Icons.edit_outlined : Icons.check_circle_outline,
                  color: AppColors.textSecondary,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 3650)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) => child!,
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedDate == null
                ? Colors.transparent
                : AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: selectedDate == null
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? (isEditing ? "No date chosen" : "Set due date")
                  : DateFormat('MMM d, yyyy').format(selectedDate!),
              style: TextStyle(
                color: selectedDate == null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              if (isEditing && widget.todo != null) {
                widget.databaseService.updateTodo(
                  widget.todo!.id,
                  titleController.text.trim(),
                  selectedDate,
                );
              } else {
                widget.databaseService.addTodo(
                  titleController.text.trim(),
                  selectedDate,
                );
              }
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(isEditing ? "Save Changes" : "Add Task"),
        ),
      ],
    );
  }
}

// Helper function to show the dialog
void showTodoDialog(
  BuildContext context,
  DatabaseService databaseService, {
  TodoModel? todo,
}) {
  showDialog(
    context: context,
    builder: (context) =>
        TodoDialogWidget(databaseService: databaseService, todo: todo),
  );
}
