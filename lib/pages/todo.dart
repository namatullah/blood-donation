import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/database_service.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final db = Provider.of<DatabaseService?>(context);

    if (user == null || db == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return StreamProvider<List<TodoModel>>.value(
      value: db.todos,
      initialData: [],
      child: const HomeScreen(),
    );
  }
}
