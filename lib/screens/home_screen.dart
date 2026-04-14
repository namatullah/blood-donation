import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/app_colors.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/todo_sort_utils.dart';
import 'package:todo_app/widgets/empty_state_widget.dart';
import 'package:todo_app/widgets/section_header_widget.dart';
import 'package:todo_app/widgets/todo_item_widget.dart';
import 'package:todo_app/widgets/todo_dialog_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<TodoModel>>(context);
    final databaseService = Provider.of<DatabaseService>(
      context,
      listen: false,
    );

    // Filter and sort todos
    final pendingTodos = TodoSortUtils.sortPendingTodos(
      todos.where((todo) => !todo.isDone).toList(),
    );
    final completedTodos = todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(
        context,
        todos,
        pendingTodos,
        completedTodos,
        databaseService,
      ),
      floatingActionButton: _buildFloatingActionButton(
        context,
        databaseService,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'My Todos',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signOut();
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<TodoModel> todos,
    List<TodoModel> pendingTodos,
    List<TodoModel> completedTodos,
    DatabaseService databaseService,
  ) {
    if (todos.isEmpty) {
      return const EmptyStateWidget();
    }

    return ListView(
      children: [
        if (pendingTodos.isNotEmpty) ...[
          SectionHeaderWidget(title: 'Pending Tasks (${pendingTodos.length})'),
          ...pendingTodos.map(
            (todo) => TodoItemWidget(
              todo: todo,
              databaseService: databaseService,
              onEdit: (editedTodo) {
                showTodoDialog(context, databaseService, todo: editedTodo);
              },
            ),
          ),
        ],
        if (completedTodos.isNotEmpty) ...[
          SectionHeaderWidget(
            title: 'Completed Tasks (${completedTodos.length})',
          ),
          ...completedTodos.map(
            (todo) => TodoItemWidget(
              todo: todo,
              databaseService: databaseService,
              onEdit: (editedTodo) {
                showTodoDialog(context, databaseService, todo: editedTodo);
              },
            ),
          ),
        ],
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(
    BuildContext context,
    DatabaseService databaseService,
  ) {
    return FloatingActionButton(
      onPressed: () {
        showTodoDialog(context, databaseService);
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
